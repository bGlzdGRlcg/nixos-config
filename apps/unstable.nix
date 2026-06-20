{ pkgs, ... }:

{
  users.users.listder.packages = with pkgs; [
    google-chrome
    firefox
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
    vlc
    yuview
    hmcl
    vscode
    calibre
    btop
    nodejs_26
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
    cherry-studio
    psmisc
    codex
    claude-code
    (pkgs.tsukimi.overrideAttrs (_: rec {
      version = "25.5.0";
      enableParallelBuilding = true;
      src = pkgs.fetchFromGitHub {
        owner = "tsukinaha";
        repo = "tsukimi";
        rev = "fc419ea97717b13ddfb27b9fb9377f105d4d949b";
        hash = "sha256-9jB1Lj1TxSMoF6wi4zyLEjh9/lhDzkHnUk6vHx5t+mA=";
      };
      cargoDeps = pkgs.rustPlatform.fetchCargoVendor {
        inherit src;
        hash = "sha256-iUaMnVo76JTUflkkZh0DnkD147Amd2UTFT2bHH3o46Q=";
      };
    }))
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
