{ config, pkgs, lib, inputs, ... }:

{
	# sudo nixos-rebuild switch --flake .#lxc-minecraft --target-host vegard@ip --ask-sudo-password
  imports = [
    ../configuration.nix
    inputs.nix-minecraft.nixosModules.minecraft-servers
  ];

  networking.hostName = "lxc-minecraft";

  nixpkgs.overlays = [ inputs.nix-minecraft.overlay ];

  networking.firewall.allowedTCPPorts = [ 25565 ];

  services.minecraft-servers = {
    enable = true;
    eula = true;
    openFirewall = true;

    servers.neoforge = {
      enable = true;

			package = pkgs.neoforgeServers."neoforge-1_21_1-21_1_233";

      serverProperties = {
        "level-seed" = "-2135836821937050197";
        "max-players" = 69;
        enable-rcon = true;
        "rcon.password" = "changeme";
      };

      jvmOpts = "-Xms8000M -Xmx8000M";

			symlinks = {
        mods = pkgs.linkFarmFromDrvs "mods" (
          builtins.attrValues {
						biomes_o_plenty = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/HXF82T3G/versions/8vIRXPpR/BiomesOPlenty-neoforge-1.21.1-21.1.0.13.jar";
              sha512 = "a238c6dbeccf9bb8f7144601e8f8fd7973d76c60344b50670141e76f49f886f6f89487eb81749dfca7c36166831924052106884a9f8dc18893261476a34d4b32";
            };

            terrablender = pkgs.fetchurl {
							url = "https://cdn.modrinth.com/data/kkmrDlKT/versions/6e8GCrLb/TerraBlender-neoforge-1.21.1-4.1.0.8.jar";
							sha512 = "18aqyzmpw0xmbmbdnaxngdm9pccs4dccbyj0p02ipzdnm87743a48qq7h319fqqw0vycj7ans1rwzdi0lcd4bnrzar0z70kwldjljwx";
						};

            create = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/LNytGWDc/versions/UjX6dr61/create-1.21.1-6.0.10.jar";
              sha512 = "11cc8fc049d2f67f6548c7abfada6b82a3adb5c7ca410a742de04bbca76e03862c518721b88d806f6e6d768a4d68531fdb903a85859b25d1484d550cc7bafd4b";
            };

            richiesprojectilelivbraty = pkgs.fetchurl {
							url = "https://cdn.modrinth.com/data/B3pb093D/versions/hZ6B2Z0x/ritchiesprojectilelib-2.1.2%2Bmc.1.21.1-neoforge.jar";
							sha512 = "0q07vkayqilq60fvgcgf84h6dkvslqzk9fzkmphrc9q6x8ylkqniyhj9h0k26jw1j83d5n09qqs5ib5ah306rhhdnwzpa550m2whr3d";
						};

            create_aeronautics = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/oWaK0Q19/versions/YhZLrAFC/create-aeronautics-bundled-1.21.1-1.2.1.jar";
              sha512 = "c7899f8a693cf1b4c17a31faf64e631383f6df331b82b517ed6abe01b0464a9f10b226f0336fa8611c5af514375716c4d009d55c7f92640445c68239b63ebc03";
            };

            create_big_cannons = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/GWp4jCJj/versions/Xd4DDnph/createbigcannons-5.11.6%2Bmc.1.21.1.jar";
              sha512 = "2s2sq74aamvq5n0sf0m9nkr54qnrmw66rkq3a46jzbcckfh4rlkfrwkl3s8wm03y8s9ys8nbvls3jlr1n7db7vgxdyi1zby1gjjjyha";
            };

            create_diesel_generators = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/ZM3tt6p1/versions/7TPYyw7R/createdieselgenerators-1.21.1-1.3.13.jar";
              sha512 = "258b650ba1ff3d447ca60795271d2cf4ff79de5ff1332f0cb701df0a8d7ccdd0e486be5ce1e95bcdd0dbd8cea86a6850e3c837d616978a0dd6390212ba4084a4";
            };

            create_radars = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/BLu2Yqfq/versions/vz0tPRci/create_radar-0.4.9.2-1.21.1.jar";
              sha512 = "ce61bd7d38ac3176d0d78def7f795001baa16b893b1607d4f6621a4b9053923cba90e474547d6e4f831d33162dfa97b418505013d5d8ce56b51087289cf852ea";
            };

            farmers_delight = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/R2OftAxM/versions/GbNuOZ4S/FarmersDelight-1.21.1-1.3.2.jar";
              sha512 = "da5a4236427df8010d75992201c8723ac84a8fa71efa55670551d333cac94a90ae8e8c536da63ae07a67f4d00dc2774ae4151030f41d26886e508f4a037c8694";
            };

            clumps = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/Wnxd13zP/versions/jo7lDoK4/Clumps-neoforge-1.21.1-19.0.0.1.jar";
              sha512 = "314d8d8e640d73041f27e0f3f2cad7aad8b4c77dbd7fb31700ef7760362261f77085eed5289555c725d99c3f47a114e7290cd608f39c9f0f12ef74958463bdcc";
            };

            simple_voice_chat = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/9eGKb6K1/versions/eFhbQnrh/voicechat-neoforge-1.21.1-2.6.18.jar";
              sha512 = "9990a758a9c1044af1dce3b96feaf7eeab91a8180fbf9e77388c1ee9983c2c0919710d87b917eb815457d926f00e68557c6a85eb8193d895ac8fe78fd7abb4c1";
            };

            forgified_fabric_api = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/Aqlf1Shp/versions/7nHK7hMg/forgified-fabric-api-0.116.7%2B2.2.4%2B1.21.1.jar";
              sha512 = "858acb32a79e7ed1f37472bd7c50e3d2f47c7d7f6e734a8cece3800eb30d565a09580c261778ea73a0ae25e10e9eb9b16866012fe61d24f671b0ffe3ae2377dd";
            };

            kotlin_for_forge = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/ordsPcFz/versions/NrSebcsG/kotlinforforge-5.11.0-all.jar";
              sha512 = "b32faa6d616511aff4f8b32197877c53b9f8bee103884ec37c632b5d017bb59a498ec971b68d8d94787043b0c5be666a330b61d285033c341bff83ac28a90992";
            };

            glitchcore = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/s3dmwKy5/versions/S2TfWrZR/GlitchCore-neoforge-1.21.1-2.1.0.2.jar";
              sha512 = "7a009ed163d03536fdfaee7b37cb1ec3073204dffcb06a683369aa88da8dbc3780b0ac69d466bb32a3ad9394c97b698d0fda676e1b4dd4edfc50ac5aa2283c32";
            };

            ferrite_core = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/uXXizFIs/versions/x7kQWVju/ferritecore-7.0.3-neoforge.jar";
              sha512 = "19af89a2075bb10a63884fa853ebf84b02c79dc3242430ecdad056fd764fdcde367a7303276b329df01b0736e2ef264c5d80c7dc92c6aebd244f556a230bb417";
            };

            sable  = pkgs.fetchurl {
							url = "https://cdn.modrinth.com/data/T9PomCSv/versions/3FMsUjO4/sable-neoforge-1.21.1-1.2.2.jar";
              sha512 = "0s7arh23agi1jpa4n6k935dqwl97r5gjwjrnlh1f9bv55fw3g1v5fjdiwgiwbiccfa7dln2rzqdy1dj92iwzjpyi3v5k8sskxj4cz7b";
            };

            someasssemblyreasuirted = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/jZi8ogTA/versions/G8Lz8Txm/someassemblyrequired-5.2.8.jar";
							sha512 = "36gk7wm5zmykwyvvrm8yj78g6ivijhx9p4vrp2gbcq5q0p12irrdkx5s36jqc0v43lxyiazbc9y8mv0g8lgdahqfwc2p1c8a5cpd76y";
            };

            create_copycats = pkgs.fetchurl {
							url = "https://cdn.modrinth.com/data/UT2M39wf/versions/kecZ0sl7/copycats-3.0.4%2Bmc.1.21.1-neoforge.jar";
							sha512 = "3z2nxdwqkr03vg4gvh8aigm10861ggb95p1v9b931g905z4ww0a0wm5h1rcwychj922ch01057qz0y8qzsajrpf1app2sp6kdjqxjgc";
						};

						createadditionscrafts = pkgs.fetchurl {
							url = "https://cdn.modrinth.com/data/kU1G12Nn/versions/qPr8V4G2/createaddition-1.6.0.jar";
							sha512 = "3m5qsks15m6cnbrsi34ygvij178p8bd5mba093gcdbqvyd9anh3akxshp6a0vk7jg4kaykvwp4zg4pc0062s0d95cdbsdsxn7pix8z3";
						};

						nochatreport = pkgs.fetchurl {
							url = "https://cdn.modrinth.com/data/qQyHxfxd/versions/ZV8eL55E/NoChatReports-NEOFORGE-1.21.1-v2.9.1.jar";
							sha512 = "0hww7kai6jh7lp9dipy5rjhmy31xkhs80gj0dflaiax1dcm36kj2bn1my7pg94xyh2fa2gq5s4fjqj5agra90any7lignxdnlikcai9";
						};

						jei = pkgs.fetchurl {
							url = "https://cdn.modrinth.com/data/u6dRKJwZ/versions/YAcQ6elZ/jei-1.21.1-neoforge-19.27.0.340.jar";
							sha512 = "2c2j95yfmy2ry5qyinp7v8cqy28bb5fpwzrvgrg1pjpnsxyb0gss21ylagwndyxhsimclzb0fzmyg30ixcp8k9yw9kzhx79r2rqxbcb";
						};

						journey_map = pkgs.fetchurl {
							url = "https://cdn.modrinth.com/data/lfHFW1mp/versions/1wPOSxW0/journeymap-neoforge-1.21.1-6.0.0-beta.82.jar";
							sha512 = "1fmzrjcharxkqi52xnmcaz8866phzw8w7idpkykhd2riwjy1c9n72vgjlawwjpaynwhaan8rlpwa2x6i1jngmcal1r90klshxhkwqxq";
						};

						map_frontiers = pkgs.fetchurl {
						  url = "https://cdn.modrinth.com/data/hWlsli6y/versions/ISVYP2Bt/MapFrontiers-1.21.1-2.7.0-beta.18-neoforge.jar";
						  sha512 = "3gqyqq8x8rypdis6wlnrln38zzzsp994rcjgln288ra9frjl3iz29rbgkw7caq817kznrg20bnzymsgrxzbm12aabkmip2hh2ivndxk";
						};

						forge_config_api = pkgs.fetchurl {
							url = "https://cdn.modrinth.com/data/ohNO6lps/versions/tWlsPKJI/ForgeConfigAPIPort-v21.1.6-1.21.1-NeoForge.jar";
							sha512 = "1v9ccrsypwrqs0zip9axagf9xswpzzc4laby605d5s6iw6lknsrpbaglb0kyv9d2r3mbzlvq9db8kl983v7l6d1286hfv74njmjaa4h";
						};
          }
        );
      };
    };
  };
}