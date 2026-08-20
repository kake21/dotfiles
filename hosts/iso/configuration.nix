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
