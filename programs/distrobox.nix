{ pkgs, ... }:

{
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
  };
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
}
