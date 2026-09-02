{ pkgs, ... }:

{
  environment.systemPackages = [ (pkgs.callPackage ../pkgs/tracker.nix { }) ];
}
