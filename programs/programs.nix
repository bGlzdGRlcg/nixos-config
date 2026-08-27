{ pkgs, ... }:

{
  programs = {
    fish = {
      enable = true;
      shellAliases = {
        rm = "safe-rm";
      };
    };
    gnupg.agent.enable = true;
    steam.enable = true;

    nix-ld = {
      enable = true;
      # Also reused verbatim as the `fhs` buildFHSEnv's extra targetPkgs in
      # system/environment.nix, so keep it good enough for prebuilt GUI
      # binaries too: pip Qt/PySide6 wheels, Electron tarballs, AppImages.
      libraries = with pkgs; [
        acl
        attr
        bzip2
        curl
        libsodium
        libssh
        libxml2
        openssl
        stdenv.cc.cc
        systemd
        util-linux
        xz
        zlib
        zstd

        # GL / EGL / GPU
        libglvnd
        mesa
        libgbm
        libdrm
        vulkan-loader
        vulkan-headers

        # X11
        libx11
        libxcb
        libxcb-cursor
        libxcb-image
        libxcb-keysyms
        libxcb-render-util
        libxcb-util
        libxcb-wm
        libxcomposite
        libxcursor
        libxdamage
        libxext
        libxfixes
        libxi
        libxkbcommon
        libxkbfile
        libxrandr
        libxrender
        libxtst

        # Wayland
        wayland

        # Text and image
        brotli
        expat
        fontconfig
        freetype
        harfbuzz
        libtiff

        # GTK stack (Qt's gtk3 platform theme, Electron)
        atk
        at-spi2-atk
        cairo
        gdk-pixbuf
        glib
        gtk3
        pango

        # Misc system services
        alsa-lib
        cups
        dbus
        krb5
        libpulseaudio
        nspr
        nss
      ];
    };

    virt-manager.enable = true;
  };
}
