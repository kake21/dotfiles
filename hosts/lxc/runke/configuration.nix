{ config, pkgs, lib, inputs, ... }:

{
  # sudo nixos-rebuild switch --flake .#lxc-runke --target-host vegard@ip --ask-sudo-password
  #
  # Server side of the "RunkePack" PrismLauncher instance. The mod list below is
  # generated from the "RunkCopy" instance -- that is the known-good copy; the
  # other instances were corrupted by a round of mod updates.
  #
  # Mods come from its packwiz index (mods/.index/*.pw.toml): every entry not
  # tagged `side = 'client'` is mirrored here, pinned by the sha512 of the jar
  # the client runs. Two wrinkles on the CurseForge side: entries with
  # `mode = 'metadata:curseforge'` carry no URL and only a sha1, so the CDN path
  # is rebuilt from `file-id` (files/<id div 1000>/<id mod 1000>/<filename>) and
  # the sha512 taken from the jar in the instance; and some CurseForge mods get
  # no index entry at all, so they are listed by hand from the jars in mods/
  # (the MineColonies and FTB families, Mining Gadgets, Twilight Forest).
  imports = [
    ../configuration.nix
    inputs.nix-minecraft.nixosModules.minecraft-servers
  ];

  networking.hostName = "lxc-runke";

  security.sudo.extraRules = [
    {
      users = [ "vegard" ];
      commands = [
        { command = "${pkgs.rsync}/bin/rsync"; options = [ "NOPASSWD" ]; }
      ];
    }
  ];

  nixpkgs.overlays = [ inputs.nix-minecraft.overlay ];

  networking.firewall.allowedTCPPorts = [ 25565 ];
  # Simple Voice Chat listens on UDP 24454.
  networking.firewall.allowedUDPPorts = [ 24454 ];

  services.minecraft-servers = {
    enable = true;
    eula = true;
    openFirewall = true;

    servers.neoforge = {
      enable = true;

      # Matches the NeoForge version the client pack runs (mmc-pack.json).
      package = pkgs.neoforgeServers."neoforge-1_21_1-21_1_250";

      serverProperties = {
        # `level-seed` is only read when a world is first generated; for an
        # existing world the seed in level.dat wins and this value is silently
        # ignored. `level-name` picks the world directory under /srv/minecraft/
        # neoforge, so changing it generates a fresh world from the seed above
        # and leaves the previous world/ untouched on disk.
        "level-seed" = "3374991501308182734";
        "level-name" = "runkepack";
        "max-players" = 69;
        motd = "RunkePack";
        enable-rcon = true;
        "rcon.password" = "changeme";
        "allow-flight" = "true";
      };

      jvmOpts = "-Xms8000M -Xmx8000M";

      symlinks = {
        mods = pkgs.linkFarmFromDrvs "mods" (
          builtins.attrValues {
            # AddonsLib
            addonslib = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/cl5ec0Qm/versions/7SEGJEQj/addonslib-neoforge-1.21.1-1.14.jar";
              sha512 = "6c5b08e0cfaa4f7e6902f6f937a955850db14fc6e09bf99881ea8ff19149644972878375a5e5dd57861d990ebf4908b03e8cd070dd166a96c2f2b8c3c72bea7f";
            };

            # Applied Energistics 2
            ae2 = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/XxWD5pD3/versions/kfyIqgJ6/appliedenergistics2-19.2.17.jar";
              sha512 = "55edfd948366aff620881e0625e48c333a2cb847e73249bc0b588efbc4b86709992a8ffbca97ea387e270df4186fe7f74ee2f27b739f1c952e932becfb9dea33";
            };

            # AE2 JEI Integration
            ae2_jei_integration = pkgs.fetchurl {
              url = "https://mediafilez.forgecdn.net/files/7727/898/ae2jeiintegration-1.2.1.jar";
              sha512 = "5aa19cdf7c97c2d2a24d74f8b84379222aa34b5ce86b86c7fb799526e8f268dfa080a4f587c9c96704b40430c7c728aa1b5391ae67346d702e2fe31e691b8c48";
            };

            # The Aether
            aether = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/YhmgMVyu/versions/K5X5qMwG/aether-1.21.1-1.5.10-neoforge.jar";
              sha512 = "4b004daed6d09362646e204f068dee28e80523e705e862778036c492775672071ca9cc95f9574a842f34d2e058b46138c6154c6a2f251dcdad7a8803907dad46";
            };

            # Apotheosis
            apotheosis = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/rqFWfVlz/versions/nEWTeHFF/Apotheosis-1.21.1-8.8.0.jar";
              sha512 = "8ae7848b2a01d407be31f4e3879cb6ec6a10310f1786625dcd5026c350a854ace0fe097388293bdd4f2ce7fe2d44aab007f08475e5c59c7f21de80137b9aa643";
            };

            # Apothic Attributes
            apothic_attributes = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/DGaH8Rh0/versions/Xtaunf84/ApothicAttributes-1.21.1-2.10.1.jar";
              sha512 = "ecfa2c6b9eca3793977a29d57961a0f552cfc1995ee5d7c6e6dcca888d4c427c4d940c484ebd13c6d2db7c7341d4da0d212e6897ec1f26f0e5c093ce508d4858";
            };

            # Apothic-Enchanting
            apothic_enchanting = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/pL8MtgqY/versions/2vH7csNR/ApothicEnchanting-1.21.1-1.6.2.jar";
              sha512 = "e03864db8d32a60116dd9b870e7ba7f62564a85180c6b35cfd486deffef4c586254c527c45ab3c0750a4224d732d2c389d2ae84dbfae99ca7f70ee2ba9e7f9c6";
            };

            # Apothic-Spawners
            apothic_spawners = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/DfxVkOAO/versions/pWfxcfO2/ApothicSpawners-1.21.1-1.4.0.jar";
              sha512 = "2fdd49cdb3e6610846c3a746ab0730d6d49412eaf8c21e3d0b9d588d80c8cd1a1d0b7e19ade7fc86fd699ac02e270e5fa01fb5cf106d24a7740692ecc1ad8820";
            };

            # AppleSkin
            appleskin = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/EsAfCjCV/versions/uAKA6Laj/appleskin-neoforge-mc1.21-3.0.9.jar";
              sha512 = "f4ea46273e407334b63e262e2555c9a8204f7b5e60f23f272fbaa83ad9e88800e0ee186aca840710df2dbe0a18b37758695fef2ae1a902c10b3706e3de772937";
            };

            # Applied Mekanistics
            applied_mekanistics = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/IiATswDj/versions/TpUCzFaW/Applied-Mekanistics-1.6.3.jar";
              sha512 = "1a693c3c05862805bd88cf1265fd4b9b98b2da4efe986c9ff26efa0e675df14373983ffdf7ededb26f07864b6702fabc299ac1a06fb8fa35de0b341b596dbf9b";
            };

            # Architectury API
            architectury_api = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/lhGA9TYQ/versions/1IiqEQGl/architectury-13.0.11-neoforge.jar";
              sha512 = "d9f7c3bb8162577dfb461ffdf04bd6a3563c7586934a0e2a744c14421beffb8286f0d88d4c758317003f20f99fe8072a39b9d675af061e036970d36db36027f0";
            };

            # Ars Énergistique
            ars_energistique = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/IJI3QuK8/versions/Bdb8HLZ0/arseng-2.1.1-beta.jar";
              sha512 = "4d6229c3c4f627e9804b2afdbeb58fedf172c70e8704b0fa91cfc4d5073bb13ede99b71cd35ee397a92b891a4f884b63bead4a7fbcbe8513fbc8f29c786f42c2";
            };

            # Ars Nouveau
            ars_nouveau = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/TKB6INcv/versions/qEFs5RRw/ars_nouveau-1.21.1-5.13.1.jar";
              sha512 = "5c7f36345faf4a16a183f3d7839c0c22a0d21638410598b23049867c87acc2e673974e2eb1d0bee1b616aca14c9642f7c97e2c28a17259cddc84b731ca95684f";
            };

            # Ars Ocultas
            ars_ocultas = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/Tsw8vbks/versions/FFn9Oxki/ars_ocultas-1.21.1-2.6.1.jar";
              sha512 = "89cd67402f37f2a49ea30325719098925baa5c671bcd5b4d39da49623edce837b96c4440d48d3efcad970e27f7e04f8d22334138b534c62eb7b466f1bcb4c8af";
            };

            # Ars Nouveau's Flavors & Delight
            arsdelight = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/BwbT0OZE/versions/a4qrRbNs/arsdelight-2.2.2.jar";
              sha512 = "74487ee0a27e4429ca017dedc56d43195bb7260d3028151708cf4c22a044472fe857e7e6da5f11fab8bc1bae8d5f4945c591afed20de0a4d8c058a947e5b16a8";
            };

            # Artifacts
            artifacts = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/P0Mu4wcQ/versions/lMfuK0o7/artifacts-neoforge-13.2.5.jar";
              sha512 = "9079bc8a22c237881b22b38027bbab2a8a2e685a1f49c1e1e0e5796f3e0a5509a130d73753c7b2980f12e4f00845f8e8c967ee969f1eadcd52139c2780afe09d";
            };

            # Balm
            balm = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/MBAkmtvl/versions/KgypwTqX/balm-neoforge-1.21.1-21.0.65.jar";
              sha512 = "779b4f9e9738ae6f010e87f71b2ed5a114eb9b1b3d5b55cf42ad538094e5b064a1d3f4ff00064aac90da1c841a144464d47378d9bffc448a71d87132cb954101";
            };

            # Biomes O' Plenty
            biomes_o_plenty = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/HXF82T3G/versions/BtZKRp69/BiomesOPlenty-neoforge-1.21.1-21.1.0.14.jar";
              sha512 = "1569d9ed5b619f99d61a7cf1b2d886b278df2905b3ce9324f8e7a17c5c960312ec681cc06f1ad96644bde2cdc60440d8be9952f0ee0f84f7937210f46fbb21d7";
            };

            # BlockUI
            blockui = pkgs.fetchurl {
              url = "https://mediafilez.forgecdn.net/files/7790/469/blockui-1.0.211-1.21.1-snapshot.jar";
              sha512 = "b31e68b526b30b1a5b58cbc624b4d586937e6ca5d4eff83cec4e48017a5b24171716c0ef146be329d5f1add738352c5ac794fb2245a9e3bf4b58326f71a0e381";
            };

            # Bookshelf
            bookshelf_lib = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/uy4Cnpcm/versions/1sdJl7J1/bookshelf-neoforge-1.21.1-21.1.81.jar";
              sha512 = "78d4577a8e8fbb241216968475dd73f5b9e5efeb7da802b18a4e6c290e49af6cb4a5676e9855d0d8ff3613f967812e4bd363bbb9196c17c954d19454f84b2214";
            };

            # Botany Pots
            botany_pots = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/U6BUTZ7K/versions/RjHfHgSn/botanypots-neoforge-1.21.1-21.1.44.jar";
              sha512 = "e8a3b2cdad657a29bf12af78bd028a44163551c0c630efa710a671b587312a294024c0aa5711b0fb89612cab0f8671dfddb59096a890fafcc2c561c2dca2b37d";
            };

            # Cannibal Villages: Tropical Exploration
            cannibal_villages = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/O1b4iO4x/versions/xkoEwbVS/cannibalvillages-2.4.6-v1.21.1.jar";
              sha512 = "6f28b06ae0f86fe69579562c2ac7cb678721ffbafb2c075f29d2b75357cd7924a83a27621f822318a6ca170a29d594182082fd0a5c90213d2773ad58c722f058";
            };

            # CC: Deep Seas
            cc_deep_seas = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/FFRmzdEr/versions/qKkaeGSS/cc_deepseas-1.1.1.jar";
              sha512 = "10e2d5f82d420666c0a570d01886a42f758ea4fe91e7b4bd50f2a599cd6a535430242b76269863f033ab15b3611dbb5ccd81df7f6ceecd357ca86ab18ec3ac56";
            };

            # CC: Redstone Link Bridge
            cc_redstone_link_bridge = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/k3y2uvYF/versions/gH50GtVz/ccredstonelinkbridge-neoforge-1.0.3.jar";
              sha512 = "d7a1cb8d4b02a25bdbebd6893e94cfb1d0702a534f9168886dcf82bec9cc6c4190dbcd0dbc11701fe0cff9b5a38fb9331874249dc7ced4fbc2e9b4dd1645e984";
            };

            # CC: Sable
            cc_sable = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/OPNBxiZD/versions/j0UWQoMG/cc_sable-neoforge-1.3.4.jar";
              sha512 = "70e7e09c8a4a566fe8bd67a8d53069083e8285a15cb680412b415f5104b5be3ad3b623c9ccd99f165996933ef5d81aa1966633796d7439f562b6e35ae59af717";
            };

            # CC: Tweaked
            cc_tweaked = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/gu7yAYhd/versions/1ewzHZYg/cc-tweaked-1.21.1-forge-1.120.2.jar";
              sha512 = "009fcf48b7d123018a61b2c55f0fede7dd1f6a6325226bf9cc926342185ca8a7e059e13662816d24595aac243abf622b682583631cfe42c3757505b2e864ff73";
            };

            # Chipped
            chipped = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/BAscRYKm/versions/eqVowbGc/chipped-neoforge-1.21.1-4.0.2.jar";
              sha512 = "f3083b01267e7c674c4b42f45a317c93ee7723443cba2051fe5bc593638b533b0fe90699e2101661c934dff458eab693cce4e188533bfe977778c249563a2fa5";
            };

            # Cloth Config API
            cloth_config = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/9s6osm5g/versions/izKINKFg/cloth-config-15.0.140-neoforge.jar";
              sha512 = "aaf9b010955b8cd294e5a92f069985b18729fd5e2cf22d351f1dff9680f15488688803ec41e77e941cbde130ceb535014ca4c868047d80ab69c2d508e216654d";
            };

            # Clumps
            clumps = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/Wnxd13zP/versions/jo7lDoK4/Clumps-neoforge-1.21.1-19.0.0.1.jar";
              sha512 = "314d8d8e640d73041f27e0f3f2cad7aad8b4c77dbd7fb31700ef7760362261f77085eed5289555c725d99c3f47a114e7290cd608f39c9f0f12ef74958463bdcc";
            };

            # Comforts
            comforts = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/SaCpeal4/versions/3kpPjcTc/comforts-neoforge-9.0.5%2B1.21.1.jar";
              sha512 = "e9de2952545e9e773a6e78fc501e8cd231ea19750c30404355b71df9928eb5bd0921a4429aeca9d0fa10e67717f77fcf7a2aae117ac953b8f7de246b0ad685e4";
            };

            # Sinytra Connector
            connector = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/u58R1TMW/versions/IITF0PRC/connector-2.0.0-beta.17%2B1.21.1-full.jar";
              sha512 = "cb92b662047208792e61191d372d1e255766200406c35769007101f8c578c1018938610c3b90352afd93ec42d7963acf3607e35c50e669df50ac85d7c5529560";
            };

            # Construction Sticks
            construction_sticks = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/ooyjDLZt/versions/5dwDOCYP/ConstructionSticks-1.21.1-1.5.0.jar";
              sha512 = "8ac03ef221e657d8c864130e03dbc0b5f45627836547128fcd866fc5f04a0a5ad66d72c1c7a3cceec906146ec728fba9dc1f976a48a62dfa40d3efabeead5ad6";
            };

            # Cooking for Blockheads
            cooking_for_blockheads = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/vJnhuDde/versions/MQCIy6VF/cookingforblockheads-neoforge-1.21.1-21.1.24.jar";
              sha512 = "bec8bb71b9540fd33bd4e5d1e5f151abc03c4fb97f1477f690d222c9710eabed876e5b2380a37bfdbc24649e1f66d8c963f13e6e738a336e9a0fdc88012d8447";
            };

            # Create: Copycats+
            copycats = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/UT2M39wf/versions/bPYeUWZx/copycats-3.0.9%2Bmc.1.21.1-neoforge.jar";
              sha512 = "432b5cde473976476b0729172710d32805576d0c3a5fd66d21f882d96cef0c4eef1b85e4e3a1a316e2adc473784b11e156b0265b0f62bcfd5b035a6ff7dfcc6e";
            };

            # Create
            create = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/LNytGWDc/versions/UjX6dr61/create-1.21.1-6.0.10.jar";
              sha512 = "11cc8fc049d2f67f6548c7abfada6b82a3adb5c7ca410a742de04bbca76e03862c518721b88d806f6e6d768a4d68531fdb903a85859b25d1484d550cc7bafd4b";
            };

            # Create Aeronautics
            create_aeronautics = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/oWaK0Q19/versions/44pLdPGg/create-aeronautics-bundled-1.21.1-1.3.2.jar";
              sha512 = "dc7e8e1148fa442243889ba29412207137e1bb86206e6c92bc0a589f1374a466e93de22bdbf14f753984d86c29308fbbdc0f14a4b9618b14c0ac1666a36b46f5";
            };

            # Create Aeronautics: Toolgun
            create_aeronautics_toolgun = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/5fUBLqeW/versions/pcD0Yutw/create_aeronautics_toolgun-0.3.6.jar";
              sha512 = "d239d0438eabf369f4f2a8d07a05f15dca5d8d89fd24fd4f369d2173c92ca7b61a6b6d48a6172896b5f9e43ed15f4b742575390a76983de2de6d4c4639e76e79";
            };

            # Create Aeronautics: Transmission & Linkage
            create_aeronautics_transmission_linkage = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/Y1dq5ioE/versions/FCZZ3ED4/create_aeronautics_transmission_linkage-0.2.8.jar";
              sha512 = "af637fc793448928354cb453f794ce08fa14694250a377ae67d4a2d40db7c4a00adcb9f980387947c264e74c575939e9f525ef1f1443b8471c10bf72c52000a5";
            };

            # Create Big Cannons
            create_big_cannons = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/GWp4jCJj/versions/bOiDu0LS/createbigcannons-5.11.7%2Bmc.1.21.1.jar";
              sha512 = "24f414dfbb973a0f4d9c9b2aa059edc7bed4d23b4f39eb1f7d23a1d6b437e3b5d64cca6e4b85ff7eb2815743fa711d54ad652bffe96d1eb1234544716006440d";
            };

            # Create: CC Total Logistics
            create_cc_total_logistics = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/FuyTRq2g/versions/24hfd7Lg/createcclogistics-1.21.1-0.3.6.jar";
              sha512 = "d3217ac82366f80de3413fefc1430bcb45e350761430011528a547e6ff875ef5f733f5fbe0477e179d3f47b859bc38379550bcb75a11b9f807d77357440ec8f0";
            };

            # Create: Coasters Simulated
            create_coasters_simulated = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/W1ZUfWdr/versions/PGhQoSBq/simulatedcoasters-0.1.5.jar";
              sha512 = "1fd31aaac63755e7cdf76de1498c9e0b38973977e66aaf49e380774ec30a1b09834f1c44e3e9ccc965403d440e4cafc46bce42f83307979bf790b6689d3cfb1f";
            };

            # Create: Connected
            create_connected = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/Vg5TIO6d/versions/Xe7EqzfQ/create_connected-1.3.3-mc1.21.1.jar";
              sha512 = "485675693980a266611669857fa9cd348e2a29140b87bf0a8ab3e13c3591422cceaa36b7a2eb90084d35ec1868c8eec9f924383bb4dada2dddcb72e9f09361b0";
            };

            # Create Deco
            create_deco = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/sMvUb4Rb/versions/qrcMVoBD/createdeco-2.1.3.jar";
              sha512 = "c536662f9d47ad57a37419165ded14835b23ad6c3e82a920298ecd7ee074244b0b6062ef9cc7ea4501ddd35919a840faccd7fc64e43eb8df31e12076681c3c0d";
            };

            # Create Deep Seas
            create_deep_seas = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/mva5q4qZ/versions/UcXaPVeD/create_submarine-2.2.4.jar";
              sha512 = "6b87d72f1036489c44cd033170abe10f8b5210ef8265823f29cd51531444e78384863ca321b7cdcc23924940161226327ab774cfd1d91d5e2ea8ba599b0eae31";
            };

            # Create: Diesel Generators
            create_diesel_generators = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/ZM3tt6p1/versions/UoPH8lO1/createdieselgenerators-1.21.1-1.3.15.jar";
              sha512 = "1507ebcd07d3185aac3ae6ce768b4d6bab16cb6f39776d25a850c8133a4dc5826b8ddbeca112d76afc64deaa37ec177cac4237c6c34621c4b65e73d83f8ab43f";
            };

            # Create: Dragons Plus
            create_dragons_plus = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/dzb1a5WV/versions/G8QQJPtF/CreateDragonsPlus-1.11.8b.jar";
              sha512 = "1795983fd4287c1aa406f7e13dff14ab9bdb14269353286b7efb150da283b98ee82e3618e459c07c67b4dd8d7b19005e38192e9208162634fd12f2f80d3d4543";
            };

            # Create: Easy Structures
            create_easy_structures = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/z69Pxatv/versions/ECkmsrG4/create_easy_structures-0.2a-neoforge-1.21.1.jar";
              sha512 = "69c340c6ef729d41e3ecb71de5d7d8db53a32dd08780458bb8828a960cd54d5d53dc19ad2aa948a0e7328013fef49dc5276edb6641eec33a52fe5f6ba373c75c";
            };

            # Create Encased
            create_encased = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/hSSqdyU1/versions/t6MATlU9/Create%20Encased-1.21.1-1.9.0-ht3.jar";
              sha512 = "ed27f640b2b30546ab2e5d8d56e6291b559ae76b1fe48b1521c0b9f10c238282a73a44e5781c71fc58088e6c8526ad5c01cf5ef54fadf5640d118ae53d8a67d4";
            };

            # Create: Enchantment Industry
            create_enchantment_industry = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/JWGBpFUP/versions/ASyjJTVL/create-enchantment-industry-2.5.3b.jar";
              sha512 = "790b80911610279af6a189d17e49f7d4c30d4646117f4208f230b15a58432873767e699afb02a4e6cdedfb104252e3c729f7191ff7f2748fde405d0f7653743c";
            };

            # Create More: Parallel Pipes
            create_more_parallel_pipes = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/5jfUeix5/versions/aYrPugrv/cmparallelpipes-neoforge-2.0.2.jar";
              sha512 = "1a08dba7a1cef3d9e4aedbdb3616eac6c1d2f0b3f77aa936c5a293e6099f40bb7805b1f53461feb9bd8a9196cf10dd8fbd27de35dd9fd5bc48a7a9de1158b072";
            };

            # Create Propulsion: Simulated
            create_propulsion_simulated = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/ApkoHNO9/versions/H13U56dc/createpropulsion-1.1.5.jar";
              sha512 = "6096c9c5cb220219a0b58b56f9fefd63f8b79a0967d326727b4206d62df1813da73956aeae2fa5b839160a1bb5af8e099726d12d2d93f10e5f157beb85bb9c52";
            };

            # Create: Radars
            create_radars = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/BLu2Yqfq/versions/AntNFNAx/create_radar-0.4.9.4-1.21.1.jar";
              sha512 = "9ce111ea7e39fe979a6d423766820bbdd8c7e61ecf72db35b94539330aadc0cd45b5eed469ef4bbfeb36b1c558209e048019f5a4a253b43f3b6b3bd4fbc8ac63";
            };

            # Create: The Air War
            create_the_air_war = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/GMrNnOis/versions/JnF14u1u/create_the_air_wars-4.67.jar";
              sha512 = "74c617d342c7c43b9ef67e22d3791a0ca7681bb64792c29ae45bfaafb2f9fe3c74d711b2c7334b008c446c1dae3eec4c208a28e55a37d27a0df2627a1e05ee5b";
            };

            # Create: Tracks
            create_tracks = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/iPv9VoMI/versions/V4hhNZeU/tracks-neoforge-1.21.1-1.0.1.jar";
              sha512 = "4875d0e5f2e6561451341ea13d6f8edea0158971b851b7e8c2c2901f128c73ee9393d4615be9950f2bfe057e7e5121d460c30a23828290917658c9dee0cd3552";
            };

            # Create Crafts & Additions
            createaddition = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/kU1G12Nn/versions/zlC557Yg/createaddition-1.7.0.jar";
              sha512 = "267779bf2a215a0be39748e6a8e387322df697bc9de8e7e9558e6885aa790a2e73f334a55bfc5f97f4130d22262011433675fd0830ab1e3e3b10c9898d8a702c";
            };

            # CreativeCore
            creativecore = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/OsZiaDHq/versions/fdEYikBb/CreativeCore_NEOFORGE_v2.13.46_mc1.21.1.jar";
              sha512 = "cae19e90001272f3d9be35b279e1c5eed6f1079740380532b5055af19fb378f32a74754beb3c9ca7d2e49f75259f6e1b44c5d602db6362bd6017b3a95d3fee75";
            };

            # Creeper Overhaul
            creeper_overhaul = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/MI1LWe93/versions/HNrAYCLH/CreeperOverhaul-neoforge-1.21.1-4.0.6.jar";
              sha512 = "880ca9d8d23b527d3583cbe7fa399b2a26421b6ccba1deacd666cf9b61f4af4378157f404ab3789a7ae9c3c8693e2b7f6c8c532e703e5bb0e1881b9cc2879a6e";
            };

            # Cucumber Library
            cucumber = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/Rw1NrDzF/versions/8421rqFF/Cucumber-1.21.1-8.0.16.jar";
              sha512 = "fbc63f23f827061b2a45f33a3867e105268b5a51d9ca92ba3bacd2e2a0af847eb4c367e726a62a455b841e503f8ce73ea9e180285670ddf3ec18a8ba4e72da7d";
            };

            # Curios API
            curios = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/vvuO3ImH/versions/yohfFbgD/curios-neoforge-9.5.1%2B1.21.1.jar";
              sha512 = "5981a267686b744e7e3c227f78cbcd5267c14ac6979a28e814695f4589273998563147207fef4a5cdb7cdbdc39797cd95d9e4abadb55869f18e02a38d0654ae5";
            };

            # Cyclops Core
            cyclops_core = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/Z9DM0LJ4/versions/2Z0ruVBB/cyclopscore-1.21.1-neoforge-1.30.0.jar";
              sha512 = "7a3a8f3a4806045e8724c6c61a177c19530f03611bb8843533a630ed97943d66fe010285c36755135cd460899fe01a2d298223f15de9ec841ba27a2b62208d24";
            };

            # Deeper and Darker
            deeperdarker = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/fnAffV0n/versions/TuD0Zvi3/deeperdarker-neoforge-1.21.1-1.4.1.jar";
              sha512 = "38d8d87878f39a063feb029db17702bedadf7554233ae56db6018c21225b6dff4d4cc31f4b0995254fd488e2a687f3b15bf9647c59dd42b9032791d34316ed0c";
            };

            # Dis-Enchanting Table
            dis_enchanting_table = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/9BgYgXE4/versions/UzZnJKSR/disenchanting_table-merged-1.21.1-5.0.2.jar";
              sha512 = "e572401caa0ac178aa1f55eec64510904aaf22924790039d9e8084e6f63bb545aa47904aa9da84e523ca44ea47a0f80440c68d94e369554261eefe58a0846dec";
            };

            # Domum Ornamentum
            domum_ornamentum = pkgs.fetchurl {
              url = "https://mediafilez.forgecdn.net/files/8784/713/domum-ornamentum-1.0.236-snapshot-main.jar";
              sha512 = "0d00bcaf1d2dc234f8a166f8af30ec1bde3c4c1dd8c5e8a05d77368276d5b7115043cc0a14cf7a747e43490e71a82456ccaadb55b24f26171fd890c070d9c890";
            };

            # Drive-By-Wire with Sable
            drive_by_wire_sable = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/KsqvI0hD/versions/zdSwg9kS/drivebywire-0.3.0.jar";
              sha512 = "09e5cac69600e20e56a9bb66d2c1fd60ff36906f47b86bc1dc27efb1624c671f61bca3c774e08d2c28b59839a914ac067f4d97b304a5ac543a7c016756a46952";
            };

            # Drive-By-Wire:Typewriter
            drive_by_wiretypewriter = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/lDYpnxit/versions/cPM0cfwo/drivebywire-typewriter-1.1.0-beta.2.jar";
              sha512 = "be2e34f84c2c31273be5282d3582f29ff16a4d53c38eaf197f7e49998e51e5a01eadad2962a1eb75e278084251373b433b74629943318438aae36360d67384e7";
            };

            # Easy Anvils
            easy_anvils = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/OZBR5JT5/versions/fSQSKhdF/EasyAnvils-v21.1.0-1.21.1-NeoForge.jar";
              sha512 = "366eed1f4831e4044566833e07e5f6201ef1d178d0b30938b8a8a34bcac08c904c95ca0afe87bd55ea06b87cce85ee70c95d0cddd0ae053b1302d288252fe98f";
            };

            # EnderChests
            enderchests = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/gxSiDoVF/versions/h1wflNQi/enderchests-neoforge-1.21.1-1.0.jar";
              sha512 = "511749a3f7c3398fd193d198cecffdda6f9aa911946ebf86b3d64a9fbde096a9bae5a090b80ae3a7a9910f4cf3d877625dad373f8485d467dee6eed0ece604f1";
            };

            # Ender IO
            enderio = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/49ZofO4f/versions/2bHl1dCW/enderio-8.2.12-beta.jar";
              sha512 = "c4415c1e835fa7eaf7f4528fd685412151968b092e9be91528add11dd981943ba6243eee41ff73923df64d59d8f907901cb006edcb5c02783e73ab656524c995";
            };

            # Enderman Overhaul
            enderman_overhaul = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/Lq6ojcWv/versions/TH9YXp9r/endermanoverhaul-neoforge-1.21.1-2.0.3.jar";
              sha512 = "d2032b35ed5dcf028a35a1d3da16a48b71d182fab1203bbf0f9f9123b99bb725730c60cdd8a9f48431c91f7ac9e04fa958aed842ee94114ade3a9418392ee6ab";
            };

            # EnderTanks
            endertanks = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/zZwEA08D/versions/yMpTLwpa/endertanks-neoforge-1.21.1-1.0.jar";
              sha512 = "4105520584d992430a018b21511f034fc1022d21d8b07e1c35f5a6843835f6f0745001f9b20b024666ec28b6d99da8f46998d7ee1b7a61c972f866c4363fb052";
            };

            # Energy Meter
            energymeter = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/MbejSZ2E/versions/Y8vglZux/energymeter-neoforge-1.21.1-0.5.2.jar";
              sha512 = "6cf9509f57d7ebd5dcaac871a6938db04898c8732441ab457695375d8731144d1a1872c0403eb2a6a848db17ed554c23b8991561317e2844cbb07565e37272bc";
            };

            # EvilCraft
            evilcraft = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/3ANq2btA/versions/vw8vbIxF/evilcraft-1.21.1-neoforge-1.2.96.jar";
              sha512 = "6ccdbbb4ae351e5b68304663d70203dd287b484ac427c5ee11e1c997a67334bd22c6d81d34155af33f58b5600e423b03e569302fe3e8eed8ce0a40709b761bd2";
            };

            # Farmer's Delight
            farmers_delight = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/R2OftAxM/versions/XTVZDOol/FarmersDelight-1.21.1-1.3.4.jar";
              sha512 = "1f6f8796469f747cff36f477b4f589a3d69613882399f9ee7f86db36c7bca9aa4828731f43db15dc6c7f5a4c1bbe3d4092a232e8cef010b09cec0581848fda90";
            };

            # FerriteCore
            ferrite_core = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/uXXizFIs/versions/x7kQWVju/ferritecore-7.0.3-neoforge.jar";
              sha512 = "19af89a2075bb10a63884fa853ebf84b02c79dc3242430ecdad056fd764fdcde367a7303276b329df01b0736e2ef264c5d80c7dc92c6aebd244f556a230bb417";
            };

            # Forgified Fabric API
            forgified_fabric_api = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/Aqlf1Shp/versions/V9WdDUTx/forgified-fabric-api-0.116.15%2B2.3.5%2B1.21.1.jar";
              sha512 = "2b44ecd839544e3668a02f8de86433d507417d068dcafeee7f698744fc2b12fd888a1bba509da57c8e2884d01dbaf344f49bbac0f22cdae599507356ed0cbe30";
            };

            # Friends&Foes (Forge/NeoForge)
            friends_and_foes_forge = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/BOCJKD49/versions/zeGwtTNo/friendsandfoes-neoforge-4.0.27%2Bmc1.21.1.jar";
              sha512 = "7575f340d8021b8da09674163b8ef8ea8f52b7e2b76da302a04c70f7ae552429a65853ea65fd513a65d9f43ba84f524a2957cc37f22e0f0265f331c6bcb4bfc4";
            };

            # FTB Chunks (NeoForge)
            ftb_chunks_forge = pkgs.fetchurl {
              url = "https://mediafilez.forgecdn.net/files/8791/113/ftb-chunks-neoforge-2101.1.22.jar";
              sha512 = "6589c6f9efb86b0f50963143a9c3c5647aeded698825189494455013441bae7973c1b83f95fce35d3f0b5239a8afd153c8b55ce4a3a6b21fd5d44ae47cecb2d8";
            };

            # FTB Library (NeoForge)
            ftb_library_forge = pkgs.fetchurl {
              url = "https://mediafilez.forgecdn.net/files/8858/846/ftb-library-neoforge-2101.1.36.jar";
              sha512 = "69b0644bd88714d8c4ad82dd5ac7a06ab850b211c4e8ee8dc779205ba3f214f83d7e4899d00f44af1ab66b263904cb5abb5073350e9783e7ed11faa1652a1944";
            };

            # FTB Teams (NeoForge)
            ftb_teams_forge = pkgs.fetchurl {
              url = "https://mediafilez.forgecdn.net/files/8724/782/ftb-teams-neoforge-2101.1.11.jar";
              sha512 = "21c9350c6c7ec54ee54b74f2bdc0a44f91005bedda3caf27d673b2f2bcad1dbef5aec970201ec8e959db2a1743ceb2e24ae99a9e36744dce740a0ab1dad01c52";
            };

            # FTB Chunks: Sable Aerospace
            ftbchunksaerospace = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/aDOJNNsW/versions/zy8ymgWP/ftbchunksaerospace-1.0.1.jar";
              sha512 = "09311c87c644bfede11b28d69389c296468a2281eb8f1097424d82d1ae7aa25dc30cbeb568b27e8d493ad12cb64b32e2958b6e3269202d26481ee15b64633003";
            };

            # Geckolib
            geckolib = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/8BmcQJ2H/versions/tPkJmim6/geckolib-neoforge-1.21.1-4.9.2.jar";
              sha512 = "c91012b16cc40c8f48f69b78cb8e2e5c006486ae2431fbd289dfc01be7a4217294becea22d83a155d6b32b3969450df871352a3695e1452168b84f41355f7b9e";
            };

            # GlitchCore
            glitchcore = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/s3dmwKy5/versions/S2TfWrZR/GlitchCore-neoforge-1.21.1-2.1.0.2.jar";
              sha512 = "7a009ed163d03536fdfaee7b37cb1ec3073204dffcb06a683369aa88da8dbc3780b0ac69d466bb32a3ad9394c97b698d0fda676e1b4dd4edfc50ac5aa2283c32";
            };

            # GraveStone Mod
            gravestone_mod = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/RYtXKJPr/versions/rMGJpjaM/gravestone-neoforge-1.21.1-1.0.40.jar";
              sha512 = "5504a222d4085da1898ff6d4dff8eb1821fd14a8caaaac785554277147f984262e63925a411db3f1a34e9c7874652fb6737176bea4c0c3f01243f5eae4ea6eaa";
            };

            # GuideME
            guideme = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/Ck4E7v7R/versions/rduAfwb7/guideme-21.1.17.jar";
              sha512 = "8b5d8cf7592d7b4759f5347c5acd1b0eb46403437b10b900f535e4cdde59ab1b37d57b71f3f67cdc99a66d55ad5d760f51b55ba2bc50aecf538f8572003e4cbf";
            };

            # Immersive Engineering
            immersiveengineering = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/tIm2nV03/versions/uNRARSH2/ImmersiveEngineering-1.21.1-12.4.2-194.jar";
              sha512 = "862523e84747a8b7eaa65f9b3c337fa832ef9efd0545c27f68e350e01f482c7a1242d0e4bdc2caff3d7eb033508b43a353fcd7150c9b544d0c05765ca2a551b3";
            };

            # Create: Interiors
            interiors = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/r4Knci2k/versions/gBrfZy6S/interiors-1.21.1-neoforge-0.6.1.jar";
              sha512 = "68b0d915e41fb0ce9d12a8c580d688a604770ded2b21e963058aa6d80cbc5661c481416d051a541395b5c79f461edcb658046e53cfcfb405179a450662ed01b5";
            };

            # Jade 🔍
            jade = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/nvQzSEkH/versions/eYz2YBGT/Jade-1.21.1-NeoForge-15.10.6.jar";
              sha512 = "dad9755dce8d85d914fc4df2baa0211f13e5839a71c1925fdd01f69081a95e30a2934e6273f8b01f0169adebe7a9dae57a8d904de0c4cb36dc17369bb474f0f2";
            };

            # Just Enough Items (JEI)
            jei = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/u6dRKJwZ/versions/ZWGz5dZX/jei-1.21.1-neoforge-19.56.0.441.jar";
              sha512 = "cee8f743819fdeb99fde9a91cd72b9200c07a7fd7e581e3b2561843fd0ee59f0b7dc7e0b619c79cee80402c7557eb4ae3b218bd05ec3e6d9e79801f01b791fa3";
            };

            # JourneyMap
            journeymap = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/lfHFW1mp/versions/F1lEUGxf/journeymap-neoforge-1.21.1-6.0.8.jar";
              sha512 = "0085d74664f65e7d62124ce1526c8e1dbe59f0d195a7dda6da55a488af249c8c708ab8bb76aa824a7d6b84865b4b2e08f09b105a0d50f7d522119834508b9f59";
            };

            # Kotlin for Forge
            kotlin_for_forge = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/ordsPcFz/versions/uhJhCT7X/kotlinforforge-5.12.0-all.jar";
              sha512 = "b8c3942f4d33179edf3f102f3d870b99dd436f8b8236dbbd31aa51b888162c692cfd88927295f24dc8b4375232f4c6c17360c5d6c4823f93cbcd7cf4bdc8bd14";
            };

            # [Let's Do] Vinery
            lets_do_vinery = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/1DWmBJVA/versions/ZywXpLC6/letsdo-vinery-neoforge-1.5.3.jar";
              sha512 = "1a99d218420f57733ec133f059e9491fa1a1ec915e2e350c54a38d6fddb5332a61608ffd3703594faf2924dcc8e9d387ca2573f3816c6b82251046df0cdea122";
            };

            # Lithium
            lithium = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/gvQqBUqZ/versions/DDUrRVCA/lithium-neoforge-0.15.4%2Bmc1.21.1.jar";
              sha512 = "2735da2088b88a8bdcd4ad02a2b6fffbfd3925557cefd4fa54b5477dfb9e582ea7f521300c060f57dff1325dd21bff276b7333363ad3371ed6893e3de9eca9cd";
            };

            # Lootr
            lootr = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/EltpO5cN/versions/ST5FHZnD/lootr-neoforge-1.21.1-1.11.38.125.jar";
              sha512 = "2e8fe46ff11a7865408d9417c31f46d80450814dd1c7ce0d67d515e4daec40eb99c95e8f83c01158d82d6c58128ab1f26e5c536fdc1a4e15b1f318a4cde3d512";
            };

            # Macaw's Biomes O' Plenty
            macaws_biomes_o_plenty = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/Tanquv9C/versions/QZd7wABw/mcwbiomesoplenty-neoforge-1.21.1-1.6.jar";
              sha512 = "7473870803e6b79c9e7e9618b357a1a6c65995b970720de5c48b9a10180666d4169f1f96c12a91de0838b797f45c086700f380d7d399490fec4b0f1bae3f5a94";
            };

            # Macaw's Bridges
            macaws_bridges = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/GURcjz8O/versions/aQ7rY7ng/mcw-bridges-3.1.2-mc1.21.1neoforge.jar";
              sha512 = "e98e476324229564132288f0a59bfcc897cff4cda7d12fe218563ca48d382d880662375687c69d1b4619144262ae09cbef130f4330474d8eacd37a21e8e9afb4";
            };

            # Macaw's Doors
            macaws_doors = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/kNxa8z3e/versions/u7BRX44F/mcw-doors-1.1.5-mc1.21.1neoforge.jar";
              sha512 = "43ddf00be46af91c009a95392a094f05017155214c46c7980042cbcf871864dc792416497019e688eb558897c87848bd70c282ec4a6d7b268e1ba30389ba987a";
            };

            # Macaw's Fences and Walls
            macaws_fences_and_walls = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/GmwLse2I/versions/jVdb0r4W/mcw-mcwfences-1.2.1-mc1.21.1neoforge.jar";
              sha512 = "9bf496a8db8c6074ab32374042ae15e87fe87d897e21de29d459556fa8d7d0e73f2718f28a0236181cfb3c1bc66c776b4d079f0a7084696ad490275ab1b9eb6e";
            };

            # Macaw's Furniture
            macaws_furniture = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/dtWC90iB/versions/Z5V3Ps7S/mcw-furniture-3.4.1-mc1.21.1neoforge.jar";
              sha512 = "93103f868a6a7b4fa613dbe908bcf83c4aaabf4719057d484d1636c98e6e3defa00d550a8988ff91d4d0a090463c25b898336e675da52c19bd3bd0ce37e053e4";
            };

            # Macaw's Holidays
            macaws_holidays = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/rH20L2Lp/versions/2mO9Xhpt/mcw-holidays-1.1.2-mc1.21.1neoforge.jar";
              sha512 = "439c93fe0a8ca363898b3d3d85e0413d7988927ae0a2716e2c4deed9a4097607087abc09a7dc60ac726d7cab9491d444e296ee57e5f0708ddb8951df2ac911a2";
            };

            # Macaw's Lights and Lamps
            macaws_lights_and_lamps = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/w4an97C2/versions/5U2kQZIL/mcw-lights-1.1.5-mc1.21.1neoforge.jar";
              sha512 = "a6e1c4419b70a3f9225ad03daafca22c8a7da432ec4939b8029455927e3b44683a20e89a3299da78f124d0438e188dad3735d2018a931ad4d553ec9d3b83a9ca";
            };

            # Macaw's Paintings
            macaws_paintings = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/okE6QVAY/versions/W9QHKmDh/mcw-paintings-1.1.0-mc1.21.1neoforge.jar";
              sha512 = "3a0680c5282f18e4e35071c24b759eb0b217dac5de98ab2e11a523f04c3a1985c26b4740793f1faeb93313a8c3e7f0df6286b6d895ba45c0d636ec8dc3150410";
            };

            # Macaw's Paths and Pavings
            macaws_paths_and_pavings = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/VRLhWB91/versions/tlymsxUG/mcw-mcwpaths-1.1.1-mc1.21.1neoforge.jar";
              sha512 = "8a7bc0100e57369fdcfbb65164fdf97cd7f6a931882d0f63aae15fd3db8975a78cc8734f34f640a5790dddaca5883d8e97117e7966dab50de479b1a8f3662678";
            };

            # Macaw's Roofs
            macaws_roofs = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/B8jaH3P1/versions/jiXRXiSt/mcw-roofs-2.3.2-mc1.21.1neoforge.jar";
              sha512 = "c0e82a3d0a3ab2f2fac5fb0bdd7c7c228f084feaa816540d3d9524f341c8b108c3bb1afecadae2e8118e6c93f0e73280c62da1af4349aca87b6aa337e5e22ae4";
            };

            # Macaw's Stairs
            macaws_stairs = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/iP3wH1ha/versions/4t8L0dGP/mcw-mcwstairs-1.0.2-mc1.21.1neoforge.jar";
              sha512 = "51533899b5e64610a642ee9e9d89eb9f193d0877a8cba16d3bfa262789334c864128b01757bff9d3db2718bd3df1fc177f9b2d45b84f06fc0a6ee15474af2fac";
            };

            # Macaw's Trapdoors
            macaws_trapdoors = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/n2fvCDlM/versions/StnP0RNi/mcw-trapdoors-1.1.5-mc1.21.1neoforge.jar";
              sha512 = "70721b55802192d678b6fb66619c6e210a49d5e829fc1951c70c27d8ed940c446979e36dd06221c6a35e358e97fb57c22c41ed0b24cd6d03519926b81d58d4b4";
            };

            # Macaw's Windows
            macaws_windows = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/C7I0BCni/versions/rQUE4LCz/mcw-mcwwindows-2.4.2-mc1.21.1neoforge.jar";
              sha512 = "7628aa390a689a211013e5856cca1c695729b1faa7e20da16fa1f8a3822d5b569631829e91222caa8f1b27c4a7d28ab49110502551551216de2fb471b6f2549f";
            };

            # Magnum Torch
            magnum_torch = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/jorDmSKv/versions/BZAhwo2r/MagnumTorch-v21.1.1-1.21.1-NeoForge.jar";
              sha512 = "254fe8a667d170b30471b46c83905126c501527efe913cbc939d40a8a7b01a3c1ad7c56b634778ed1599ebf2a99b9443828bc787d8ada4561bd1f8c3c61eecdf";
            };

            # Mekanism
            mekanism = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/Ce6I4WUE/versions/5KzzycBT/Mekanism-1.21.1-10.7.19.85.jar";
              sha512 = "66745825330a98f3e4a5ea3a44aff8b00870f715c144edc38dd2f61b4240589600b58ae89efac3b54dbb5aa430b1059dac1a28fd71cac5cc9002bbeb5ba3f22b";
            };

            # Mekanism Additions
            mekanism_additions = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/a6F3uASn/versions/6mkdykZa/MekanismAdditions-1.21.1-10.7.19.85.jar";
              sha512 = "6bdd4b00d19f316c7486ec27e78fe1204427fea4ad1c15c13a395956c4d1d7eb7f55438f0399b623820eae02fa5a690cece6cbb57c1b5923e1185c389bf0ddb7";
            };

            # Mekanism Generators
            mekanism_generators = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/OFVYKsAk/versions/a6gl7srE/MekanismGenerators-1.21.1-10.7.19.85.jar";
              sha512 = "6c3d5b7ea2f67f43c3d169c97de2855a7085f38019cf426e015ccc8ca9bc4f66e96b1cdf4a9afdc92bef7b2e236f16c81415ed5e48736805d5961d29525316d6";
            };

            # Mekanism Tools
            mekanism_tools = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/tqQpq1lt/versions/v5zlSE9s/MekanismTools-1.21.1-10.7.19.85.jar";
              sha512 = "0dccc47efbb9e3bf3b7df886cefff4a6b9a3f683bf0df3e54409dc3a4c6459eef95ce0af93adf345b868e5b7dcb7a2bb0af68f0a94acfa69975bfbb278e4902f";
            };

            # MezzConfig
            mezzconfig = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/7tEfOcA7/versions/XK83qXpJ/mezz_config-1.21.1-neoforge-0.5.9.jar";
              sha512 = "83951a19cd38030771c4081605cb66c67a66a32a526b4ffbd438919abb7d7b753ade216bcf6cec847c2a7ca275e6d7a25119a568007deb023df89019f1c5f93e";
            };

            # MineColonies
            minecolonies = pkgs.fetchurl {
              url = "https://mediafilez.forgecdn.net/files/8872/247/minecolonies-1.1.1387-1.21.1-snapshot.jar";
              sha512 = "9ee08a6730ee85c0acbab6764bd388da5b58e162812383eb32627d3ae42a57165590540708aca11bf6e49791cbc29a7117c2843656c181baeb345839388446ab";
            };

            # Mining Gadgets
            mining_gadgets = pkgs.fetchurl {
              url = "https://mediafilez.forgecdn.net/files/8860/674/mininggadgets-1.18.8.jar";
              sha512 = "8279a90d037832ccdfc984cabf8cdd22e7e461591463ec141978c76939c0ae58a4274da1fc4520802616982eedf26d7ef070d81d25d294ef25ad33cd80827960";
            };

            # Create Radars: Mobile Radars
            mobile_radars = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/f6vfNoDc/versions/bS9l5n2X/create_radar_mobile_radars-1.0.0.jar";
              sha512 = "304c2d9ac6f79f05ac75fc06051ebee7b866795f01b048fdc4d7811ce778dd3abeae6f64cf1a7196db381013427dd00c17757f2e64ecb1bc7ef2801b7cbe4d00";
            };

            # Modonomicon
            modonomicon = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/692GClaE/versions/jH6bsw4F/modonomicon-1.21.1-neoforge-1.120.4.jar";
              sha512 = "797c0e5270ce2772968dffbe60143fa123653e7204a0ab816f24fa09a9db38aa6cb3bbccca5a9133b4df341cc47a8a6bce3ff0f95bd2011f7afb023450eef9a0";
            };

            # MonoLib
            monolib = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/9leXt4A5/versions/nL0TTR3C/monolib-neoforge-1.21.1-4.1.0.jar";
              sha512 = "18442afd352c8500b76db1e051215196855f67423f3f85bae7bbf5777dceaca8ec38cf45c53cac66218ed01b08a9502676d3fdfb4eef6e970b8c7eb4904da109";
            };

            # Moonlight Lib
            moonlight = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/twkfQtEc/versions/BnjVBHVl/moonlight-1.21.1-3.6.4-neoforge.jar";
              sha512 = "8b5695b9f892a6ade3054ead703c763e568164f781cf32d2c76a1daf6e0b28ab336ed13441d4c71d1605cc95f58bb1f2d87f7674f7f33a93c0a1592a6c4a447a";
            };

            # Multi-Piston
            multi_piston = pkgs.fetchurl {
              url = "https://mediafilez.forgecdn.net/files/7097/877/multipiston-1.2.58-1.21.1.jar";
              sha512 = "60007e72516857228c45cbfee14ec18c9c4e89b626ecdd659fff3a146d5dc527d52563645e3348b79820f7eeb0b6d3aeab4394e7b6d6a065666ed04333c05a48";
            };

            # Mystical Agradditions
            mystical_agradditions = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/pl0jGXIx/versions/31EVEM35/MysticalAgradditions-1.21.1-8.0.14.jar";
              sha512 = "17f54c31bfef52152f2f54ed147b2f809c45f632bdb45846ddf0680dd5e95c0481cec4e8b43d1d22159b3ecafe54ba497248d306c636945579d1311ea2f253a2";
            };

            # Mystical Agriculture
            mystical_agriculture = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/C95ReXie/versions/PLakgT6X/MysticalAgriculture-1.21.1-8.0.28.jar";
              sha512 = "49d8ffe1d3ff51fb778949b480070b041f607b452e56ce8b50fe0ae992fce210a2077d45a550fc5976c2964b6551dd44ed0ccd8ff3b7859b091c546642a09632";
            };

            # Naturalist
            naturalist = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/F8BQNPWX/versions/BLB7ktFs/naturalist-2.0.3-neoforge-1.21.1.jar";
              sha512 = "fa6fbe15ecf3d1a9621849274e97895b277762c334609a96d20714e469b2dd6b1a04d333077acf126aed1e1fb5222a5de7331525eb5eef17d93cab59573c5ba4";
            };

            # Nature's Compass
            natures_compass = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/fPetb5Kh/versions/nFniEtJV/NaturesCompass-1.21.1-3.4.0-neoforge.jar";
              sha512 = "5314b536bcb9a594a9cf2bbd46c82468d17e1559bd6c00da9d91e96c0814f50416799a011705f0d184bd731dac3f03dec009c76fea3d02b3556a6013f9649014";
            };

            # NetherPortalFix
            netherportalfix = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/nPZr02ET/versions/O09BGtgh/netherportalfix-neoforge-1.21.1-21.1.1.jar";
              sha512 = "be26c53b4e7aa9dc27b05fe4cafdd120a3d1356410b35d25381d473bd9a7aa19ce6cec1bb982fda842f2a663d15dec5d12248b50141f9479a5e9ec33ed2ab3f7";
            };

            # No Chat Reports
            no_chat_reports = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/qQyHxfxd/versions/ZV8eL55E/NoChatReports-NEOFORGE-1.21.1-v2.9.1.jar";
              sha512 = "292a3623b5addb17e9f15681a4f2534562e9882ef809e504f49da4778fafc12e21a71995b5d05554d435201f401ace1e86af50e6e26f6ce9d203a5896a1ece21";
            };

            # Occultism
            occultism = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/sbJh4AZw/versions/g2DSjK89/occultism-1.21.1-neoforge-1.224.4.jar";
              sha512 = "d58f90b95412892a25e7c7af43ca56d7b4f2baf558bbb14334631e8e74469a2414d3ca25224529c352a03c3b0808ea6fbb8ab93c8efdaf6e88f144c5491f1af2";
            };

            # Ocean's Delight
            oceans_delight = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/DGiq4ZSW/versions/ja5Qg1xw/oceansdelight-neoforge-1.0.4-1.21.1.jar";
              sha512 = "8079160938175f9d0c1b8f10587c40e3c6b54210511109331f0bb37a845aa90522f60c4e668688e8a0b4023e0464b80d44f50a6af39572fe519d48c9581a9f15";
            };

            # oωo (owo-lib)
            owo_lib = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/ccKDOlHs/versions/NMCHU6DZ/owo-lib-neoforge-0.12.15.5-beta.1%2B1.21.jar";
              sha512 = "4de5c5d52139244b8c5260d641087664d992624b822599a32e03c08eb133be854a2f413667dbca1e55772445b04a70210c17b3bc13e3c88e425e7d928104b9fa";
            };

            # Pam's HarvestCraft 2: Crops
            pams_harvestcraft_2_crops = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/5xO6VNlk/versions/zlZevQk0/pamhc2crops-NEOFORGE-1.21.1-1.0.0.jar";
              sha512 = "bc84f119a25fa58c61c826b543ab26b4c430a5cf9e4f9506840429666f5638878d65e04ec4a05c4d8a00ea4e374c1b4214c696ecfb8d871a5b2e8578b9359ede";
            };

            # Pam's HarvestCraft 2: Food Core
            pams_harvestcraft_2_food_core = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/Z9OywhE4/versions/IHVdcpYW/pamhc2foodcore-NEOFORGE-1.21.1-1.0.2.jar";
              sha512 = "9c0ab3dba4589d74e67829f565a013a586f0d94118c12c6fb1d60961614bd46a1a5433030601dcfdce2b727437e5c8089d85d85d16a2fa210059d8cc6ec878ce";
            };

            # Pam's HarvestCraft 2 - Food Extended
            pams_harvestcraft_2_food_extended = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/bdPeAbPS/versions/8Jv3MDxv/pamhc2foodextended-NEOFORGE-1.21.1-1.0.0.jar";
              sha512 = "bda4ab7dcd172a8f6cd1aa98de7c663bc6803aa2856df95d0c21ced90e4a2c6c27e9976a78809ca078e7489678c0106fd81b07eec7ac429628dd9945375eecb0";
            };

            # Pam's HarvestCraft 2 - Trees
            pams_harvestcraft_2_trees = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/KDzWXxuG/versions/8AQrMyL9/pamhc2trees-NEOFORGE-1.21.1-1.0.4.jar";
              sha512 = "3451264bf892838b745e07f06abd427224dfc7c64c182ea56d08fc010d584a60d4735afaac99a479db718c76cafea7dbc70e34764b6f7db49e7bfdf584a4f865";
            };

            # Patchouli
            patchouli = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/nU0bVIaL/versions/BIogJv2D/Patchouli-1.21.1-93-NEOFORGE.jar";
              sha512 = "0b5c172db9a6eeecb5ca44b359a83548c3a60be7ff313959acdfc1e5b8039736c18e57e947d435b52d06da31159d2d02ea36e5742668dbc826308a4c99e4039f";
            };

            # Ping Wheel
            ping_wheel = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/QQXAdCzh/versions/Zrh2Fmn9/Ping-Wheel-1.12.2-neoforge-1.21.1.jar";
              sha512 = "d9f289464fa85c8af34bc57044a6f03abc0ccf4d93bc67451d1e68386be0e3b55524a68dcbf529773859f9166e09cf1fe848c83f1c0c1d10a374819d120d2554";
            };

            # Pipez
            pipez = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/iRmWy6ga/versions/BPGKb8pi/pipez-neoforge-1.21.1-1.2.31.jar";
              sha512 = "7291230b62104b73b04564d6d39ba18d11134a5713ee79242c7ae8885d07c4efb5f5d0ab75b8ff9aba3119ed8163d0c5488ad603a2db21b92dc35715b723ce5e";
            };

            # Placebo
            placebo = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/tCkE8p2N/versions/1Ypo4tf4/Placebo-1.21.1-9.9.2.jar";
              sha512 = "e8b4ba06fdbcdef8f936c39e7ba18bbfd326fad8d2512fd6cec80c899001b506a501b1aeac5eef2a1c2d7dd98f89ae3d94fac357c243027d623e59622bd295b5";
            };

            # Polymorph
            polymorph = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/tagwiZkJ/versions/9yWvrF5o/polymorph-neoforge-1.2.0%2B1.21.1.jar";
              sha512 = "dce77fffebae80532fec39d35c9c8b5817ba756bb03569022cc0854a8a6cf1868690f91451b587bd60d813e8403b5de91adbc324796bc423ef28deecfb13c775";
            };

            # Prickle
            prickle = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/aaRl8GiW/versions/EE1FHDyD/prickle-neoforge-1.21.1-21.1.11.jar";
              sha512 = "154d42795ccf1f3e07714775cdb82fd5db17574319286ced13d86b0456b64e4cf5bb89ffbcbfcefce67b73ed0b83e4e2944e493d79d9a385ff9de23006ee7bf5";
            };

            # Productive Bees
            productivebees = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/jH6iiqkd/versions/hpPcu64f/productivebees-1.21.1-13.13.0.jar";
              sha512 = "a1d539ccfed5213ab561a774e178d8f56ee6bc7e0cb4a2b4abed683a30433ceb2af3210283fbbf0d53ae7a6b63feb059522c70d41e4c320e0ee91b2c0364293c";
            };

            # Puzzles Lib
            puzzles_lib = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/QAGBst4M/versions/lh44g7RC/PuzzlesLib-v21.1.60-mc1.21.1-NeoForge.jar";
              sha512 = "630bea2bfeed34074d82bc75a4e3f94bb8235d5ae4b13d59c3ee8832bd493eb34584e81d183c5447bd1754e1845d8397eb910d16678243f64e7df8389ce147ac";
            };

            # Rapid Leaf Decay
            rapid_leaf_decay = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/jSQXzmcf/versions/5jGrYR7B/RapidLeafDecay-1.21.1-3.0.1.jar";
              sha512 = "2259dfcc3a3e04817bf7f9e9c636c5c0553676ecc0c81e89372b617d41202f3b163a13ea0af7ba1249cf02f0208c1ef48f5c83651cb9aa6b8adcbfcb592a9c62";
            };

            # Relics
            relics_mod = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/OCJRPujW/versions/WKEe9sPL/relics-1.21.1-0.12.8.jar";
              sha512 = "4490d5d1f7ae24fe69135151b5730018ec7f2e64970349d590564c70d8d67f94d805c5680866086b4c8ba9afb4999b9c0b97b869b6fb24a90808e9ca73974b7f";
            };

            # Resourceful Config
            resourceful_config = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/M1953qlQ/versions/lSbyRD6v/resourcefulconfig-neoforge-1.21-3.0.11.jar";
              sha512 = "8e4ccc37732b3f5190e7e98df34dbc1339fe614494fcabf1aeaeab9ad8e5993522964b51be31882000c08c48a6d0096b5458364415bb81f2b2b775a7daf2eb87";
            };

            # Resourceful Lib
            resourceful_lib = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/G1hIVOrD/versions/x99nCLTm/resourcefullib-neoforge-1.21-3.0.12.jar";
              sha512 = "a9d20e345faa9bcb297bd95ac9524205834804d1bb13518397dd4f7f62b352b08c3339ee7f7870d3669078ceeb33d5c31ea527aecce4b31d62ec1ff7d8b562c8";
            };

            # Ritchie's Projectile Library
            rpl = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/B3pb093D/versions/hZ6B2Z0x/ritchiesprojectilelib-2.1.2%2Bmc.1.21.1-neoforge.jar";
              sha512 = "6d64c84505a5a8fbb96d106603065465c5a2314ec09636900c5c1a31014c12fa68f1a41e758313cbf0d6f95d9a1f53bd67339020f7d8db0e184c23f66aee0330";
            };

            # Sable
            sable = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/T9PomCSv/versions/U678xqle/sable-neoforge-1.21.1-2.0.5.jar";
              sha512 = "bf3d8c87bcc5efb99afffd50305fc978086ed48a63e106816e3a8a3901f8052f4480ea527dbd7d4003f7775ed4d020529098034f4e307aefac9cc42df2b4c19a";
            };

            # Serene Seasons
            serene_seasons = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/e0bNACJD/versions/pHEgQQUE/SereneSeasons-neoforge-1.21.1-10.1.0.9.jar";
              sha512 = "a85209de65af7999b29af850e05ad3a045c208a005ec3a7e4e66a58f1c9d90fda501ba80a6245209a4aad856ee053c21c4f679efe8c02981746e907915e31fe1";
            };

            # ShatterLib | OctoLib
            shatterbyte_lib = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/RH2KUdKJ/versions/yVCCi6TK/OctoLib-NEOFORGE-0.6.2%2B1.21.jar";
              sha512 = "c33faa056c9d5403f06b7aa883290c86c33dcea3502f99720df98eccbd819cd3050fb2ffecf048f2dbee1b69a14e9dc6c23245f35ba3a78e46b056859666a60a";
            };

            # ShetiPhianCore
            shetiphiancore = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/oX7uP2kS/versions/qWurdalj/shetiphiancore-neoforge-1.21.1-1.1.jar";
              sha512 = "40e2c8daa71972bae3b80054b8a3f53a698779326cd83ca7b7954e94d507a51158a3dca42d8cab2861577d2cf3304f9276eac3b252f8056515e307c150c8da92";
            };

            # Shulker Box Tooltip
            shulkerboxtooltip = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/2M01OLQq/versions/IuqNIoAi/shulkerboxtooltip-neoforge-5.1.9%2B1.21.1.jar";
              sha512 = "805e4566c63d240d9ec01fa0b785e1b6d5be323db9476a041b96cb026e19496f00d5a14d3a94ce999884e44bc5cd7e725ece6f13f7d5952acc274ffb1fc183ab";
            };

            # Simple Voice Chat
            simple_voice_chat = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/9eGKb6K1/versions/Dv1fH2I2/voicechat-neoforge-1.21.1-2.6.23.jar";
              sha512 = "8d3dfb8b34658dfa9786a7a8db3b80e4a49ef602905ec35e449d197e327e5baee114f8a6724cfbfee08df44654761d08610f2552a156a222135fb98422da0486";
            };

            # Create Slice & Dice
            slice_and_dice = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/GmjmRQ0A/versions/N67LJgrN/sliceanddice-4.3.3-neoforge.jar";
              sha512 = "3bdbd282ae5aa11ef6c186b752497541730b50fb400c4962230bcd7734cfe4e8daa2ee565387450dfe0eb6deaa0fa44bf81f99c788bac09b1a60d8f1991db37f";
            };

            # SmartBrainLib
            smartbrainlib = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/PuyPazRT/versions/O5EpeqI3/SmartBrainLib-neoforge-1.21.1-1.16.11.jar";
              sha512 = "bfc76f6fd8c388d01b80601ad1b826f6b3f5ec5ea915e5725af129561e6bc4a10890975e6f6d2a0348d842c13042dcf1a9d0a1574fba76bce60119bee76e2dc2";
            };

            # Sophisticated Backpacks
            sophisticated_backpacks = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/TyCTlI4b/versions/AhPnzNtJ/sophisticatedbackpacks-1.21.1-3.26.3.2158.jar";
              sha512 = "66fe369708023762bff15e981c21ba5f73a7d286ee04d128838e439c63db1e9a61028acb820675ad2e22f238d3586e7cd006a579254df81740a99dc51dcdf279";
            };

            # Sophisticated Core
            sophisticated_core = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/nmoqTijg/versions/PXl6rB3q/sophisticatedcore-1.21.1-1.5.1.2341.jar";
              sha512 = "0cb1ea870d3e76591935b8e6b0239c3cce598c57ac8cedcbc4e91a7b611d45df984b6b7d82037e5cf490b2c0731709b1efcb9455d2699eda0a8c378a857999dd";
            };

            # Sophisticated Storage
            sophisticated_storage = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/hMlaZH8f/versions/H7wGZ8Sl/sophisticatedstorage-1.21.1-1.5.91.2127.jar";
              sha512 = "d8548870cb96a6fd6f50b22dc4822a8acc68168c85efb7a1878d2e0f853334011ff3e17a14dfdf2a7f3f7dde0e995046650a5ca12b9b881dc378ff3c3275375b";
            };

            # Sound Physics Remastered
            sound_physics_remastered = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/qyVF9oeo/versions/Dd2tmpsk/sound-physics-remastered-neoforge-1.21.1-1.5.1.jar";
              sha512 = "ff7e9f0b968eeb2ba0e833328a122813cad0434cfe2d5c3d527c1c0d564504f13a737fc05f22d3fea562a2f86568d31b95212bf5347dd10da36cd49ad56143a6";
            };

            # Starcatcher
            starcatcher = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/h2jXvxNR/versions/6cnwGavZ/starcatcher-3.1.4.1-NEOFORGE-1.21.1.jar";
              sha512 = "485b4602010c4f65abd3cf2feb190513fa92f7b824929986f0fcf3425ac5eeb552da36b31a76c047570592593c4b5a3ea44f228ea1e98378ddff43eec9e86c15";
            };

            # Starcatcher's Delight
            starcatchers_delight = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/NCXwQVxD/versions/Yh9v3OLC/starcatcher_delight-3.0.1-NEOFORGE-1.21.1.jar";
              sha512 = "7d8583febdfd4406431138c91cf555e9b3c193aba37630a6575e7aed2278692c3d1a74a8b342746c350f0414a3dc4f1d6c89e4dc2615cb5e35a6db41288160c9";
            };

            # Structurize
            structurize = pkgs.fetchurl {
              url = "https://mediafilez.forgecdn.net/files/8829/722/structurize-1.0.833-1.21.1-snapshot.jar";
              sha512 = "93a0b723c5a90da8b6ab45e9773836c92132d63db1eefa516c731ddd3cf8b98ec2ea98e5d3fc3d1c40ca649cdf20134334a37038d8cf51792ef164c28165cab4";
            };

            # Supplementaries
            supplementaries = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/fFEIiSDQ/versions/WrZWfRjP/supplementaries-1.21.1-3.9.9-neoforge.jar";
              sha512 = "f341d0971e644255c063f0cb363bb93e312f4f005304f8af76d7249c3cbc0c258f415cf6e7bddcdf02115ade9ba9a205ec6d062e2626b414afaef5725667f079";
            };

            # TerraBlender
            terrablender = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/kkmrDlKT/versions/6e8GCrLb/TerraBlender-neoforge-1.21.1-4.1.0.8.jar";
              sha512 = "9d4b2a1be5139c0fb2fad92ed21805b17d9e83b6ea48e637e018bb14063c1823a206390755dbfe8d025c20fd62ac11cdd84db53ddb956dabaeda01bff57bac50";
            };

            # The Twilight Forest
            the_twilight_forest = pkgs.fetchurl {
              url = "https://mediafilez.forgecdn.net/files/7797/302/twilightforest-1.21.1-4.8.3345-universal.jar";
              sha512 = "371dd7079b174091363327df70ed64c84e8e36fcab49b4c33bbcbe39650f6bccc12d3e14818cdfbbaa519a999f64a0a92c03ec981f55a315b044dc7cb5c27ef4";
            };

            # Twilight Forest - Dungeons & Villages
            the_twilight_forest_dungeons_villages = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/eDeSn4Ds/versions/A9TVfJO0/tf_dnv-2.0.3.jar";
              sha512 = "c36147d0deae1f81730a2383af372ffa04dcd391ee522f72e08bfb373bb1afabace488650f09df2487c9a71a460b9801795842b53e9729403b723f5d86153c20";
            };

            # TownTalk
            towntalk = pkgs.fetchurl {
              url = "https://mediafilez.forgecdn.net/files/5653/504/towntalk-1.2.0.jar";
              sha512 = "2414089d190045fea8ee80779a33f569827195ebbba41df712fa2feb7226f9d23b3b9be79d74515dd4207d8ac8d6549ccb22c2f9ea6ac6780da79cf7c4eb741d";
            };

            # Tropicraft
            tropicraft = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/20zpzIT1/versions/20oDt9Q4/Tropicraft-9.8.1.jar";
              sha512 = "b3c8ed1b2988718016d4a99610824a45d5df536ec0b4f697d44672f2898e15150997950df06fe2dac6cc11d5c99aa9c2e0b1a56c0a37c5360b2448e9a28fdb6c";
            };

            # Twilight's Flavor & Delight
            twilight_delight = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/d6cSefpO/versions/HNXR3CwJ/twilightdelight-3.2.2.jar";
              sha512 = "a21281486fe1847a2f5dddcc2cbf03f3a8945142052dbb1b28e623d7da34fd4d819ab49c3389a606fdf965f9ebf42cdaa03627fefb6ecd074830d00d6fabbc36";
            };

            # Visual Workbench
            visual_workbench = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/kfqD1JRw/versions/3646RfLS/VisualWorkbench-v21.1.2-1.21.1-NeoForge.jar";
              sha512 = "3737a436143acc1c6f80d0633371dafb4e24026d585bf5afa80421e1d1d6bbd2243d040c43a70d6796377227c0762d058c27c2b16a3fb20d0c2602bd04ae2038";
            };

            # Voxy Server Side
            voxy_server_side = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/84zcagOb/versions/Vm3P8eng/voxy-server-side-neoforge.jar";
              sha512 = "5a43cef07dfb4a475af91a191d38da7ff4025b3921cf1031679d96e955ed8b6425ecb2c4fd4388d9bd3c327f011b263bbed0471d27d777f2ba07e760a434d957";
            };

            # VS / Sable Hose Connectors
            vs_hose_connectors = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/YaZEkFmd/versions/vz6TdXa7/VS-Sable-HoseConnectors-0.1.8-1.21.1.jar";
              sha512 = "a7cf414277588a47df870681d5e978fe703c1b9170b7c8e9be2646123fee14ed381c6336fa1ddcc073bd6f8542f7d4cc014dda9992bdac20aabd82f25eafbfee";
            };

            # Waystones
            waystones = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/LOpKHB2A/versions/XKHZmiJm/waystones-neoforge-1.21.1-21.1.44.jar";
              sha512 = "f965f124bac88223998cef7549e88edef28ca8147b5f9281797e090316a64f4221db0d59185cb5faa0dcd17df66905b978d63e687239f172ad1a7b7d316e8e18";
            };

            # YUNG's API
            yungs_api = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/Ua7DFN59/versions/K3Dp2T0P/YungsApi-1.21.1-NeoForge-5.1.8.jar";
              sha512 = "83520e057a949ed6e8dcee33984ae0eef83c2e57d001ffbbba0b51090176608f7378327ece773312543cd8cbb802f951b7c24b57f3ab6cf19d2be10b47af30d0";
            };

            # YUNG's Better Caves
            yungs_better_caves = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/Dfu00ggU/versions/Feo6YOjN/YungsBetterCaves-1.21.1-NeoForge-3.1.6.jar";
              sha512 = "a5fa3881a32a96c25c8012aac347221363792d68491ae1f6e26d345264f7acff7c7562d6c96e0ee2f00c63ad50351742763a740f0965cc9ca0b97808f8847bba";
            };

            # YUNG's Better Desert Temples
            yungs_better_desert_temples = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/XNlO7sBv/versions/GQ9iNWkI/YungsBetterDesertTemples-1.21.1-NeoForge-4.1.5.jar";
              sha512 = "6454c955f75f66104810e967a59ae032ddf1ccc5a854346af6bfba6e44cd456e755cd8feb1e0968be4e9132ea6c5d1cb2126fe5e85d3eb18c8d3ea3c81ffdf9a";
            };

            # YUNG's Better Dungeons
            yungs_better_dungeons = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/o1C1Dkj5/versions/D6aZn0Em/YungsBetterDungeons-1.21.1-NeoForge-5.1.4.jar";
              sha512 = "40513bacd13fa9860abcab507b1fc09dc51649af4b615ce466e0ec361557f02d35e6e44bea1cc17cb4120805f862aad01394eb185f46611e7be63dfd97f272df";
            };

            # YUNG's Better End Island
            yungs_better_end_island = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/2BwBOmBQ/versions/I52NZ1qK/YungsBetterEndIsland-1.21.1-NeoForge-3.1.2.jar";
              sha512 = "02923a1a97eb81ec13d69bdc6b7e8b36dfb9e6f1a98adfcf103707ec3afde35831ccd4b210e9b3a9c7662541c38ea593a3d94c12171b4072ea7feafa75c95f96";
            };

            # YUNG's Better Jungle Temples
            yungs_better_jungle_temples = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/z9Ve58Ih/versions/P00i2hJn/YungsBetterJungleTemples-1.21.1-NeoForge-3.1.2.jar";
              sha512 = "eca4233e874a55886c63d2111b8685d479771d3627bad2922582e65b78c51ba74733dc4624aabf91f2a2178a940a72d9209ae33eef74e34f84f07d62256709d9";
            };

            # YUNG's Better Mineshafts
            yungs_better_mineshafts = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/HjmxVlSr/versions/Go3nbneL/YungsBetterMineshafts-1.21.1-NeoForge-5.1.1.jar";
              sha512 = "8b01b386f53feeaa55f0c62697578b82e00501e45e428b2a68df6bda34efb6a4b3b4e3582abf13fe767ebcb61aef9368186f53c03999958bef38f31c41a7f8b2";
            };

            # YUNG's Better Nether Fortresses
            yungs_better_nether_fortresses = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/Z2mXHnxP/versions/iopJiJQp/YungsBetterNetherFortresses-1.21.1-NeoForge-3.1.5.jar";
              sha512 = "18b461298d3df1215fa3b4d2c0cb2ef1c7ed76701d8a0bb140277b21923e31abd939f0fd9b400c5bd676d739f1cda31c43b4dc753f9187251542223f3424d336";
            };

            # YUNG's Better Ocean Monuments
            yungs_better_ocean_monuments = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/3dT9sgt4/versions/yFjEcj2g/YungsBetterOceanMonuments-1.21.1-NeoForge-4.1.2.jar";
              sha512 = "77c864da36f1d2173e6460dc335996893a804954b8a5c274173fc95dfdbf437e80d9dce32f6060306a662fc35322566eecf5dfe24e2d3fab79bf7e0ff9fa4db6";
            };

            # YUNG's Better Strongholds
            yungs_better_strongholds = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/kidLKymU/versions/8U0dIfSM/YungsBetterStrongholds-1.21.1-NeoForge-5.1.3.jar";
              sha512 = "385d67e07f2c67af5ea387d92d92949d8f671e8f99204457b6396dbe987ac3b14c2bff765df5fcbaa68016604f82a1fc6ec5a69c012ca22ad088d1a7c9bc135d";
            };

            # YUNG's Better Witch Huts
            yungs_better_witch_huts = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/t5FRdP87/versions/AvedwcIe/YungsBetterWitchHuts-1.21.1-NeoForge-4.1.1.jar";
              sha512 = "9baa8a1f36a2a36efc3df58ab9347fd9f326b551ad78e3f600ed9d68862c619752ac0770804807efb15a46fcb4d9f6e2baf6a11f622d3ebb6c865662f6c7bcfd";
            };

            # YUNG's Bridges
            yungs_bridges = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/Ht4BfYp6/versions/urkCzBf6/YungsBridges-1.21.1-NeoForge-5.1.1.jar";
              sha512 = "20b07ae4c08974980f976bcae32f18ccb885745d6cd50d4a5d0156eb5c51c29e49f8b2bf7dc2ae160d39b62f2332513bd9850efc5cba13697e36a2ac2848bc3b";
            };

            # YUNG's Cave Biomes
            yungs_cave_biomes = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/cs7iGVq1/versions/HYGqXWqQ/YungsCaveBiomes-1.21.1-NeoForge-3.1.1.jar";
              sha512 = "9e88b5109e06c791f27c23df16ebd2c535b5b27cf9b748ee6a439dccf3e560d32110b81ace5ea7dcca2992394b439223c20e4f2688e80e263efa103e2b154024";
            };

            # YUNG's Extras
            yungs_extras = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/ZYgyPyfq/versions/N2EpMhR7/YungsExtras-1.21.1-NeoForge-5.1.1.jar";
              sha512 = "d4ef831a034977abdcaec40a7662adbc37c32cf141c68245250da501f6ada2ce193c5351166fbcf2ffb1c452b60bfca8ac578963332aa4a1b523e43912b8cb8c";
            };
          }
        );
      };
    };
  };
}
