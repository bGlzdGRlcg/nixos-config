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
      steam
      steam-run
      steamcmd
    ];
    variables = {
      EDITOR = "vim";
      NIXPKGS_ALLOW_UNFREE = 1;
      ELECTRON_OZONE_PLATFORM_HINT = "wayland";
    };
  };
}
