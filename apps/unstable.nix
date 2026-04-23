{ pkgs, ... }:

{
  users.users.listder.packages = with pkgs; [
    google-chrome
    cmake
    telegram-desktop
    libreoffice
    localsend
    protonup-qt
    reqable
    scrcpy
    android-tools
    termius
    qbittorrent
    android-studio
    aseprite
    blender
    obs-studio
    fontforge
    gimp
    inkscape
    synfigstudio
    musescore
    qview
    rawtherapee
    ardour
    audacity
    lmms
    losslesscut-bin
    mkvtoolnix
    subtitlecomposer
    tagger
    tsukimi
    vlc
    yuview
    hmcl
    vscode
    calibre
    btop
    nodejs_25
    pnpm
    pkg-config
    zlib
    opencv
    gcc
    go
    gopls
    flutter
    jdk25
    gradle
    maven
    python315
    deadbeef
    opencode
    _010editor
    splayer
    rustup
    cargo
    (callPackage ./apifox.nix { })
    (writeShellScriptBin "envjs" ''
      set -euo pipefail

      local_bin="$PWD/node_modules/.bin"

      if [ -d "$local_bin" ]; then
        export PATH="$local_bin:$PATH"
      fi

      if [ "$#" -eq 0 ]; then
        exec ${fish}/bin/fish
      else
        exec "$@"
      fi
    '')
    jetbrains.datagrip
    kdePackages.kcharselect
    kdePackages.kleopatra
    kdePackages.kdenlive
  ];
}
