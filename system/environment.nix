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
      mtr
      traceroute
      nexttrace
      file
      binwalk
      clang
      clang-tools
      tree
      aria2
      direnv
      unrar
      p7zip
      unzip
      safe-rm
      dnsutils
      rng-tools
      iw
      qemu
      swtpm
      dnsmasq
      asusctl
      intel-undervolt
      virtio-win
      pkg-config
      gnumake
      ffmpeg
      arp-scan
      nix-ld
      patchelf
      (
        let
          base = pkgs.appimageTools.defaultFhsEnvArgs;
        in
        pkgs.buildFHSEnv (
          base
          // {
            name = "fhs";
            targetPkgs =
              pkgs:
              (base.targetPkgs pkgs)
              ++ (with pkgs; [
                glib
                gtk3
                nss
                nspr
                atk
                at-spi2-atk
                cairo
                pango
                gdk-pixbuf
                dbus
                cups

                libX11
                libXcomposite
                libXdamage
                libXext
                libXfixes
                libXrandr
                libxcb
                libxkbcommon

                mesa
                libgbm
                libdrm
                vulkan-loader

                alsa-lib
                expat
              ]);
            profile = "export FHS=1";
            runScript = "bash";
            extraOutputsToInstall = [ "dev" ];
          }
        )
      )
    ];
    variables = {
      EDITOR = "vim";
      NIXPKGS_ALLOW_UNFREE = 1;
      ELECTRON_OZONE_PLATFORM_HINT = "wayland";
      LD_LIBRARY_PATH = ".";
    };
    shellAliases = {
      rm = "safe-rm";
    };
  };
}
