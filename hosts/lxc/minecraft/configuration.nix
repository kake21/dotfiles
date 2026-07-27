{ config, pkgs, lib, inputs, ... }:

{
	# sudo nixos-rebuild switch --flake .#lxc-minecraft --target-host vegard@ip --ask-sudo-password
  imports = [
    ../configuration.nix
    inputs.nix-minecraft.nixosModules.minecraft-servers
  ];

  networking.hostName = "lxc-minecraft";

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
              url = "https://cdn.modrinth.com/data/HXF82T3G/versions/BtZKRp69/BiomesOPlenty-neoforge-1.21.1-21.1.0.14.jar";
              sha512 = "3bj3fvgyh8754zphh7yxw2jk6zdhh04qv6y5ga4cvcilvy03ilfq4h3jrf7r8g7z0j97kmk0llxyy5jhvcb5wbw3bb9k7v1bgnxjs8m";
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
              url = "https://cdn.modrinth.com/data/oWaK0Q19/versions/w7zlLnea/create-aeronautics-bundled-1.21.1-1.3.0.jar";
              sha512 = "1wfg76ybcpx6csqh29y8k6z9idbbzxyvsgdp7j51h5k24xdndlnnj1i3db008svkirsik0f8a2zjq8d0xiqn406md18vv50cvhs5fra";
            };

            create_big_cannons = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/GWp4jCJj/versions/bOiDu0LS/createbigcannons-5.11.7%2Bmc.1.21.1.jar";
              sha512 = "06l81k0f524a8xi3rnykzrbcnnm87biz91mg0djgvzqajvfr96dddg36ysdd893glgynfag7g9d9gn7xmcs0alvki6hyflppggi9x14";
            };

            create_diesel_generators = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/ZM3tt6p1/versions/Kijd1iDy/createdieselgenerators-1.21.1-1.3.14.jar";
              sha512 = "07rmlzlzq4y6vdv10x1vaxfj2d32gadb5lhqkp462gr4nw7kinl6q8k37g4x7i77w39kkj9j3s08c843wqpjdbmxg7rrdpx18xj11lk";
            };

            create_radars = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/BLu2Yqfq/versions/AntNFNAx/create_radar-0.4.9.4-1.21.1.jar";
              sha512 = "1isrj7vshxnnfrzni9s597m360097i0b32v2dpbpx5yysflxsslbkf0ml536fa5p4sxnwng3vkcgn5x1f16cds2dnd9gzirgvm13qcw";
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
              url = "https://cdn.modrinth.com/data/9eGKb6K1/versions/8xOu3Um5/voicechat-neoforge-1.21.1-2.6.20.jar";
              sha512 = "12wgs4j07ml1ahhn7g5ljs3rcaw7q7rgdhr7ms56kq3qz1r9vv73yacc42kwa9lqhgfnv7pq48jla1d5a0cgjsjw0zb98jg8xgjnjwk";
            };

            forgified_fabric_api = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/Aqlf1Shp/versions/dAxle9F7/forgified-fabric-api-0.116.14%2B2.3.0%2B1.21.1.jar";
              sha512 = "1r5varn9a2h9nx9d2f2fa92b72ryg0zg43mb9x7q9z4gh7azlwvj98jajmjijrp94b7bjx3wh9bilxm3g25yzzmmdjzsklbwqc01fwx";
            };

            kotlin_for_forge = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/ordsPcFz/versions/uhJhCT7X/kotlinforforge-5.12.0-all.jar";
              sha512 = "0abvj5xyiycvjwk7y1c9mn5c1rw3ipl6993gd689pr9awlji3yjqs9c2s4bhlda66yxndl2idpl7pcr1f3ksbqh7zgrw5rk9lpr9hxq";
            };

            glitchcore = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/s3dmwKy5/versions/S2TfWrZR/GlitchCore-neoforge-1.21.1-2.1.0.2.jar";
              sha512 = "7a009ed163d03536fdfaee7b37cb1ec3073204dffcb06a683369aa88da8dbc3780b0ac69d466bb32a3ad9394c97b698d0fda676e1b4dd4edfc50ac5aa2283c32";
            };

            ferrite_core = pkgs.fetchurl {
              url = "https://cdn.modrinth.com/data/uXXizFIs/versions/x7kQWVju/ferritecore-7.0.3-neoforge.jar";
              sha512 = "19af89a2075bb10a63884fa853ebf84b02c79dc3242430ecdad056fd764fdcde367a7303276b329df01b0736e2ef264c5d80c7dc92c6aebd244f556a230bb417";
            };

            sable = pkgs.fetchurl {
							url = "https://cdn.modrinth.com/data/T9PomCSv/versions/1L6XJqnY/sable-neoforge-1.21.1-2.0.3.jar";
              sha512 = "06swqsd1mn1rs9sdhq3q2alckvnch6slxm0jp6v56x9ma5w6ik8z03r1k9jzbrvmxd2d0n0sk3y6xlsqnkd6p4hc59j0700hsh4sg61";
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

						starcatcher = pkgs.fetchurl {
							url = "https://cdn.modrinth.com/data/h2jXvxNR/versions/gDYg666K/starcatcher-3.0.6-NEOFORGE-1.21.1.jar";
							sha512 = "2dk0ymhgi13p4sr63qrkrfj4a2kn80h6j71nxn7wfs3kvj9spc57g38c9xiyalar4s44pwzgs5izlfkv81hcz20wayjfkxkh6nqxc54";
						};

						create_enchantment_industry = pkgs.fetchurl {
							url = "https://cdn.modrinth.com/data/JWGBpFUP/versions/8XedJhwv/create-enchantment-industry-2.5.0-preview-alpha1.jar";
							sha512 = "25rqr7sfim4sdfxwhsjr0rp0p6jwfgfc1iz3g1hc2z7bvbj9nah564sk3cd6n9v262vdrn0ppndb9riz3yl5al5x4aixnqwpxwgqzr8";
						};

						create_tracks_plus = pkgs.fetchurl {
							url = "https://cdn.modrinth.com/data/E8eHF2Yl/versions/cju2ayQC/tracks_plus-1.0.5.jar";
							sha512 = "2vql13cq6kc9ldcxfxa118apbqkrmsk3cqj7a9309ias4c8sk5klif1vdh8j20kxkpkdlm5avnxv53vy2hi4gkyasdws5pd8v7xiy39";
						};

						nochatreport = pkgs.fetchurl {
							url = "https://cdn.modrinth.com/data/qQyHxfxd/versions/ZV8eL55E/NoChatReports-NEOFORGE-1.21.1-v2.9.1.jar";
							sha512 = "0hww7kai6jh7lp9dipy5rjhmy31xkhs80gj0dflaiax1dcm36kj2bn1my7pg94xyh2fa2gq5s4fjqj5agra90any7lignxdnlikcai9";
						};

						jei = pkgs.fetchurl {
							url = "https://cdn.modrinth.com/data/u6dRKJwZ/versions/bEGnP8IF/jei-1.21.1-neoforge-19.39.0.368.jar";
							sha512 = "2rhgg7l17h0q63qqq321410rpd0k7vx4whkxdyv51326d0xif9yvdn709m7d889g3h9mvil0yymv074p0y5ygq5c6h4hzzavmfxrzp0";
						};

						journey_map = pkgs.fetchurl {
							url = "https://cdn.modrinth.com/data/lfHFW1mp/versions/plEVc4Oq/journeymap-neoforge-1.21.1-6.0.1.jar";
							sha512 = "2lp92mlkb7yilv916zrcfih3s6nfjsdj2bbqpqdfkj5k3bni5la8318ig8zmm6sw6s9mz73i4h1g4cz8z7g8xwxsaai4npqy5qipv7q";
						};

						map_frontiers = pkgs.fetchurl {
						  url = "https://cdn.modrinth.com/data/hWlsli6y/versions/FXlk9fAD/MapFrontiers-1.21.1-neoforge-3.0.0-beta.10.jar";
						  sha512 = "3dqdnnj5grryc8bnvdg5vgvgha2mn0c5vc406nz04vaych87yv3cl5miz35xn7rkj1zbbgaw5ldf62cc35jnwyn28rcfx4a3s20nvrw";
						};

						forge_config_api = pkgs.fetchurl {
							url = "https://cdn.modrinth.com/data/ohNO6lps/versions/tWlsPKJI/ForgeConfigAPIPort-v21.1.6-1.21.1-NeoForge.jar";
							sha512 = "1v9ccrsypwrqs0zip9axagf9xswpzzc4laby605d5s6iw6lknsrpbaglb0kyv9d2r3mbzlvq9db8kl983v7l6d1286hfv74njmjaa4h";
						};

						create_dragons_plus = pkgs.fetchurl {
							url = "https://cdn.modrinth.com/data/dzb1a5WV/versions/lSnZyFnZ/CreateDragonsPlus-1.11.2b.jar";
							sha512 = "1vzrshcc6dw0xfbr7raw4py5hfrs6a0nphgrsmrbqys72xcry6dvlxbpaqp36k9v8v2dvlfygw1x6sdbgv22nijsj2cmsnk5qhdqd6a";
						};

						drivebywire_typewriter = pkgs.fetchurl {
							url = "https://cdn.modrinth.com/data/lDYpnxit/versions/cPM0cfwo/drivebywire-typewriter-1.1.0-beta.2.jar";
							sha512 = "3kq8wync1iy7aiqhhql76b2fhxl6frpa510hy72fpms2qi9mnnix875a679jjbygwcsz3n3ad6nmwczya13ab98wlxjfc9c9kw38bmy";
						};

						drivebywire = pkgs.fetchurl {
							url = "https://cdn.modrinth.com/data/KsqvI0hD/versions/zdSwg9kS/drivebywire-0.3.0.jar";
							sha512 = "196k92ncw0pqfjlmjjh9cwp9mzhdb0lm4wrid985j6y0x67lfy627v79iib3vr7vk0npf27dy83dzv0zp0x4rmvm5b0xqh0jv3cmr89";
						};

						create_connected = pkgs.fetchurl {
							url = "https://cdn.modrinth.com/data/Vg5TIO6d/versions/klOWKza5/create_connected-1.3.2-mc1.21.1.jar";
							sha512 = "3h254y15xdnmb0rca5a7bb36fgyh23x05h0wr6v5lk101312vwwfjcs3626s4b3kaq49qr36qkg140lw7q1awjzvfqn7bghxg2znyxh";
						};

						create_slice_and_dice = pkgs.fetchurl {
							url = "https://cdn.modrinth.com/data/GmjmRQ0A/versions/cV2GZBSJ/sliceanddice-neoforge-4.3.2.jar";
							sha512 = "320qnvj1dny8shm1hw8y8chlr7ig2240rxgh58r73k4nvd0xj2js8plzl00wgka1vxc09wrslxmlw558dgf1b2ayjd6lr5y8ry7k4sh";
						};
          }
        );
      };
    };
  };
}