{ pkgs, config, ... }:

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
      nixd
      alejandra
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
      wireguard-tools
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
      OVMF
      edk2
      podman-compose
      xwininfo
      yad
      scummvm
      inotify-tools
      xdotool
      xvfb
      (pkgs.writeShellScriptBin "qemu-system-x86_64-uefi" ''
        qemu-system-x86_64 \
        -bios ${pkgs.OVMF.fd}/FV/OVMF.fd \
        "$@"
      '')
      (
        let
          base = pkgs.appimageTools.defaultFhsEnvArgs;
        in
        pkgs.buildFHSEnv (
          base
          // {
            name = "fhs";
            targetPkgs = pkgs: (base.targetPkgs pkgs) ++ config.programs.nix-ld.libraries;
            profile = ''
              export FHS=1
              # Nix-store interpreters (e.g. a venv's python) ignore /usr/lib,
              # so pip wheels with unpatched .so files need it on the search path.
              export LD_LIBRARY_PATH=/usr/lib
            '';
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
      PNPM_HOME = "$HOME/.local/share/pnpm";
      PKG_CONFIG_PATH = "/etc/profiles/per-user/listder/lib/pkgconfig:/run/current-system/sw/lib/pkgconfig";
    };
    shellAliases = {
      rm = "safe-rm";
    };
  };
}
