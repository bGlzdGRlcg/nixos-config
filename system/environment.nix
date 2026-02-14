{ pkgs, ... }:

{
  environment = {
    systemPackages = with pkgs; [
      git
      wget
      vim
      minimal-grub-theme
      where-is-my-sddm-theme
      fastfetch
      htop
      dae
      nixfmt
      nil
      podman
      distrobox
      gnupg
      gh
      tree
      aria2
    ];
    variables = {
      EDITOR = "vim";
      NIXPKGS_ALLOW_UNFREE = 1;
      ELECTRON_OZONE_PLATFORM_HINT = "wayland";
    };
  };
}
