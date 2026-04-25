{pkgs, config, inputs, ...}: {
    environment.systemPackages = with pkgs; [ #`home.packages` if using home manager
        # replace or repeat for any included package
        inputs.nix-citizen.packages.${pkgs.stdenv.hostPlatform.system}.rsi-launcher
    ];
}