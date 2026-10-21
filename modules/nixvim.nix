{ pkgs, inputs, ... }:
let
  lua = raw: { __raw = raw; };
  # Keymap shorthand: nmap "<leader>ff" "Snacks.picker.files()" "Find files"
  nmap = key: action: desc: {
    mode = "n";
    inherit key;
    action = lua "function() ${action} end";
    options.desc = desc;
  };
  cmd = key: command: desc: {
    mode = "n";
    inherit key;
    action = "<cmd>${command}<cr>";
    options.desc = desc;
  };
in
{
  imports = [
    inputs.nixvim.homeModules.nixvim
  ];

  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    nixpkgs.source = inputs.nixpkgs; # we follow nixpkgs on purpose; silences nixvim's warning
    # claude is installed system-wide (modules/cli-apps.nix); nixvim's own nixpkgs
    # instance refuses it as unfree, and a second copy would be redundant anyway
    dependencies.claude-code.enable = false;

    # Colours come from Stylix (modules/stylix.nix), like the rest of the desktop.

    # Tools nvim shells out to. nodejs is here rather than system-wide because
    # projectNext normally runs in Docker; neotest and overseer need it on PATH.
    extraPackages = with pkgs; [
      ripgrep
      fd
      lazygit
      nodejs
    ];

    globals = {
      mapleader = " ";
      maplocalleader = " ";
    };

    opts = {
      number = true;
      relativenumber = true;
      signcolumn = "yes";
      cursorline = true;
      scrolloff = 8;
      # projectNext style: 4-space indent, enforced by ESLint
      expandtab = true;
      shiftwidth = 4;
      tabstop = 4;
      smartindent = true;
      ignorecase = true;
      smartcase = true;
      undofile = true;
      updatetime = 250;
      splitright = true;
      splitbelow = true;
      clipboard = "unnamedplus";
      wrap = false;
      termguicolors = true;
    };

    # lspconfig only starts the compose server for this filetype
    filetype.pattern."docker%-compose.*%.ya?ml" = "yaml.docker-compose";

    diagnostic.settings = {
      virtual_text = true;
      severity_sort = true;
      float.border = "rounded";
    };

    # lspconfig's :LspEslintFixAll gives up after 1s, which type-aware rules in
    # projectNext regularly exceed, so the fixes were silently dropped.
    extraConfigLuaPre = ''
      function EslintFix(bufnr)
        bufnr = bufnr == 0 and vim.api.nvim_get_current_buf() or bufnr
        local client = vim.lsp.get_clients({ bufnr = bufnr, name = "eslint" })[1]
        if not client then return end
        client:request_sync("workspace/executeCommand", {
          command = "eslint.applyAllFixes",
          arguments = { { uri = vim.uri_from_bufnr(bufnr), version = vim.lsp.util.buf_versions[bufnr] } },
        }, 5000, bufnr)
      end
    '';

    # Let kitty's background_opacity show through. Only groups painted in exactly
    # kitty's background colour are translucent, and Stylix gives panels
    # (explorer, pickers, floats) a lighter base01, so drop their bg while keeping
    # fg/borders. Pmenu stays solid so completion is readable over code.
    extraConfigLuaPost = ''
      local function clear_bg()
        for _, name in ipairs({
          "Normal", "NormalNC", "NormalFloat", "FloatBorder", "FloatTitle", "FloatFooter",
          "SignColumn", "LineNr", "LineNrAbove", "LineNrBelow", "FoldColumn",
          "EndOfBuffer", "WinSeparator", "SnacksNormal", "SnacksNormalNC",
        }) do
          local hl = vim.api.nvim_get_hl(0, { name = name, link = false })
          hl.bg, hl.ctermbg = nil, nil
          vim.api.nvim_set_hl(0, name, hl)
        end
      end
      clear_bg()
      vim.api.nvim_create_autocmd("ColorScheme", { callback = clear_bg })
    '';

    autoGroups.format_on_save.clear = true;
    autoCmd = [
      # ESLint is the formatter in projectNext (no Prettier config); fix on save.
      {
        event = "BufWritePre";
        group = "format_on_save";
        pattern = [ "*.ts" "*.tsx" "*.js" "*.jsx" "*.mjs" ];
        callback = lua ''
          function(args)
            if vim.g.disable_autoformat then return end
            EslintFix(args.buf)
          end
        '';
      }
      {
        event = "TextYankPost";
        callback = lua "function() vim.hl.on_yank() end";
      }
    ];

    userCommands.FormatToggle = {
      command = lua ''
        function()
          vim.g.disable_autoformat = not vim.g.disable_autoformat
          vim.notify("Format on save " .. (vim.g.disable_autoformat and "off" or "on"))
        end
      '';
      desc = "Toggle ESLint fix on save";
    };

    # Native vim.lsp.config; defaults come from nvim-lspconfig.
    plugins.lspconfig.enable = true;
    lsp = {
      inlayHints.enable = false;
      servers = {
        vtsls = {
          enable = true;
          config.settings = {
            vtsls.autoUseWorkspaceTsdk = true;
            typescript = {
              # Large codebase: give tsserver room
              tsserver.maxTsServerMemory = 8192;
              # Match the repo: `@/...` aliases over relative paths
              preferences.importModuleSpecifier = "non-relative";
              updateImportsOnFileMove.enabled = "always";
              inlayHints = {
                parameterNames.enabled = "literals";
                functionLikeReturnTypes.enabled = true;
              };
            };
          };
        };
        eslint.enable = true;
        tailwindcss.enable = true;
        cssls.enable = true; # css + scss
        stylelint_lsp = {
          enable = true;
          # nixpkgs names the binary stylelint-lsp, lspconfig expects stylelint-language-server
          config.cmd = [ "stylelint-lsp" "--stdio" ];
          config.filetypes = [ "css" "scss" ];
        };
        prismals.enable = true;
        jsonls.enable = true;
        yamlls.enable = true;
        dockerls.enable = true;
        docker_compose_language_service.enable = true;
        bashls.enable = true;
        marksman.enable = true; # docs/ wiki
        nixd.enable = true;
      };
    };

    plugins = {
      web-devicons.enable = true;
      lualine.enable = true;
      which-key.enable = true;
      schemastore.enable = true; # JSON/YAML schemas: package.json, tsconfig, docker-compose, GH Actions

      treesitter = {
        enable = true;
        settings = {
          highlight.enable = true;
          indent.enable = true;
        };
      };
      ts-autotag.enable = true; # JSX tags
      ts-comments.enable = true; # correct `gc` inside TSX
      nvim-autopairs.enable = true;
      nvim-surround.enable = true;
      flash.enable = true;
      todo-comments.enable = true;

      blink-cmp = {
        enable = true;
        settings = {
          keymap.preset = "default"; # C-y accept, C-n/C-p select, C-space open
          completion.documentation.auto_show = true;
          signature.enabled = true;
          sources.default = [ "lsp" "path" "buffer" ];
        };
      };

      snacks = {
        enable = true;
        settings = {
          picker.enabled = true;
          lazygit.enabled = true;
          terminal.enabled = true;
          notifier.enabled = true;
          indent.enabled = true;
          input.enabled = true;
          bigfile.enabled = true;
          words.enabled = true; # highlight references under cursor
        };
      };

      oil = {
        enable = true;
        settings.view_options.show_hidden = true;
      };

      gitsigns = {
        enable = true;
        settings.current_line_blame = true;
      };
      diffview.enable = true;

      trouble.enable = true;
      grug-far.enable = true; # project-wide search & replace
      persistence.enable = true; # per-directory sessions

      # Runs package.json scripts (docker:dev, lint, migrate, ...) via :OverseerRun
      overseer.enable = true;

      # Claude Code IDE integration: shares the open file/selection, shows edits as diffs
      claudecode.enable = true;

      neotest = {
        enable = true;
        adapters.jest = {
          enable = true;
          settings = {
            jestCommand = "npx jest";
            jestConfigFile = "jest.config.ts";
            env.IGNORE_SERVER_ONLY = "true";
            cwd = lua "function() return vim.fn.getcwd() end";
          };
        };
      };
    };

    keymaps = [
      # Find (WebStorm: Shift Shift / Ctrl+Shift+F)
      (nmap "<leader><space>" "Snacks.picker.smart()" "Smart find files")
      (nmap "<leader>ff" "Snacks.picker.files()" "Find files")
      (nmap "<leader>fg" "Snacks.picker.grep()" "Grep project")
      (nmap "<leader>fw" "Snacks.picker.grep_word()" "Grep word under cursor")
      (nmap "<leader>fb" "Snacks.picker.buffers()" "Buffers")
      (nmap "<leader>fr" "Snacks.picker.recent()" "Recent files")
      (nmap "<leader>fs" "Snacks.picker.lsp_workspace_symbols()" "Workspace symbols")
      (nmap "<leader>fp" "Snacks.picker.files({ cwd = 'src/prisma/schema' })" "Prisma schemas")
      (nmap "<leader>fd" "Snacks.picker.files({ cwd = 'docs' })" "Project docs")
      (nmap "<leader>fh" "Snacks.picker.help()" "Help")
      (nmap "<leader>fk" "Snacks.picker.keymaps()" "Keymaps")
      (nmap "<leader>sr" "require('grug-far').open()" "Search & replace")

      # Files
      (cmd "-" "Oil" "Open parent directory")
      (nmap "<leader>e" "Snacks.explorer()" "File explorer")

      # LSP (built-in: K hover, grn rename, gra code action, ]d/[d diagnostics)
      (nmap "gd" "Snacks.picker.lsp_definitions()" "Go to definition")
      (nmap "gr" "Snacks.picker.lsp_references()" "References")
      (nmap "gI" "Snacks.picker.lsp_implementations()" "Implementations")
      (nmap "gy" "Snacks.picker.lsp_type_definitions()" "Type definition")
      (nmap "<leader>ss" "Snacks.picker.lsp_symbols()" "Document symbols")
      (nmap "<leader>cr" "vim.lsp.buf.rename()" "Rename")
      (nmap "<leader>ca" "vim.lsp.buf.code_action()" "Code action")
      (nmap "<leader>co" "vim.lsp.buf.code_action({ apply = true, context = { only = { 'source.organizeImports' }, diagnostics = {} } })" "Organize imports")
      (nmap "<leader>cm" "vim.lsp.buf.code_action({ apply = true, context = { only = { 'source.addMissingImports.ts' }, diagnostics = {} } })" "Add missing imports")
      (nmap "<leader>cf" "EslintFix(0)" "ESLint fix file")
      (cmd "<leader>cF" "FormatToggle" "Toggle fix on save")
      (cmd "<leader>ch" "lua vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())" "Toggle inlay hints")
      (cmd "<leader>xx" "Trouble diagnostics toggle" "Workspace diagnostics")
      (cmd "<leader>xb" "Trouble diagnostics toggle filter.buf=0" "Buffer diagnostics")
      (cmd "<leader>xt" "Trouble todo toggle" "TODOs")

      # Git
      (nmap "<leader>gg" "Snacks.lazygit()" "Lazygit")
      (cmd "<leader>gd" "DiffviewOpen" "Diff working tree")
      (cmd "<leader>gm" "DiffviewOpen origin/main...HEAD" "Diff branch vs main (PR view)")
      (cmd "<leader>gh" "DiffviewFileHistory %" "File history")
      (cmd "<leader>gq" "DiffviewClose" "Close diffview")
      (cmd "<leader>gb" "Gitsigns blame_line" "Blame line")
      (cmd "<leader>gr" "Gitsigns reset_hunk" "Reset hunk")
      (cmd "<leader>gs" "Gitsigns stage_hunk" "Stage hunk")
      (cmd "]h" "Gitsigns next_hunk" "Next hunk")
      (cmd "[h" "Gitsigns prev_hunk" "Prev hunk")

      # Tests (jest)
      (nmap "<leader>tt" "require('neotest').run.run()" "Run nearest test")
      (nmap "<leader>tf" "require('neotest').run.run(vim.fn.expand('%'))" "Run test file")
      (nmap "<leader>tl" "require('neotest').run.run_last()" "Rerun last test")
      (nmap "<leader>ts" "require('neotest').summary.toggle()" "Test summary")
      (nmap "<leader>to" "require('neotest').output.open({ enter = true })" "Test output")

      # Tasks / terminal (npm scripts: docker:dev, lint, docker:migrate:dev, ...)
      (cmd "<leader>rr" "OverseerRun" "Run npm script")
      (cmd "<leader>rt" "OverseerToggle" "Task list")
      (nmap "<C-/>" "Snacks.terminal()" "Terminal")

      # Claude Code
      (cmd "<leader>ac" "ClaudeCode" "Toggle Claude")
      (cmd "<leader>af" "ClaudeCodeFocus" "Focus Claude")
      (cmd "<leader>ar" "ClaudeCode --resume" "Resume conversation")
      (cmd "<leader>ab" "ClaudeCodeAdd %" "Add current file")
      (cmd "<leader>aa" "ClaudeCodeDiffAccept" "Accept diff")
      (cmd "<leader>ad" "ClaudeCodeDiffDeny" "Reject diff")
      {
        mode = "v";
        key = "<leader>as";
        action = "<cmd>ClaudeCodeSend<cr>";
        options.desc = "Send selection to Claude";
      }

      # Sessions
      (nmap "<leader>qs" "require('persistence').load()" "Restore session")

      # Motion
      {
        mode = [ "n" "x" "o" ];
        key = "s";
        action = lua "function() require('flash').jump() end";
        options.desc = "Flash jump";
      }
      {
        mode = "t";
        key = "<C-/>";
        action = "<cmd>close<cr>";
        options.desc = "Hide terminal";
      }
    ];
  };
}
