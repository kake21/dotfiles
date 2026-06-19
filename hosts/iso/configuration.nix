{ config, pkgs, modulesPath, ... }:
{
	imports = [
		"${modulesPath}/installer/cd-dvd/installation-cd-graphical-base.nix"
	];

	services.xserver.displayManager.sddm.enable = true;
	services.xserver.desktopManager.plasma6.enable = true;

	environment.systemPackages = with pkgs; [
		git
		firefox
	];

	nix.settings.experimental-features = [ "nix-command" "flakes" ];

	isoImage.isoName = "nixos-installer.iso";
}

#evaluation warning: The option `isoImage.isoName' defined in `/nix/store/w1qr2simx3bh9hdclbykva9w8md9nfyr-source/hosts/iso/configuration.nix' has been renamed to `image.fileName'.
#evaluation warning: The option `services.xserver.desktopManager.plasma6.enable' defined in `/nix/store/w1qr2simx3bh9hdclbykva9w8md9nfyr-source/hosts/iso/configuration.nix' has been renamed to `services.desktopManager.plasma6.enable'.
#evaluation warning: The option `services.xserver.displayManager.sddm.enable' defined in `/nix/store/w1qr2simx3bh9hdclbykva9w8md9nfyr-source/hosts/iso/configuration.nix' has been renamed to `services.displayManager.sddm.enable'.