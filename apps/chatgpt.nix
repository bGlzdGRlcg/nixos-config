{
  lib,
  stdenvNoCC,
  fetchurl,
  autoPatchelfHook,
  dpkg,
  imagemagick,
  makeWrapper,
  alsa-lib,
  at-spi2-atk,
  atk,
  cairo,
  cups,
  dbus,
  expat,
  gdk-pixbuf,
  glib,
  graphite2,
  gtk3,
  libdrm,
  libgbm,
  libGL,
  libnotify,
  libsecret,
  libusb1,
  libX11,
  libxcb,
  libXcomposite,
  libXdamage,
  libXext,
  libXfixes,
  libxkbcommon,
  libXrandr,
  libxshmfence,
  nspr,
  nss,
  openssl,
  pango,
  stdenv,
  udev,
  vulkan-loader,
  xdg-utils,
}:

let
  runtimeLibs = [
    alsa-lib
    at-spi2-atk
    atk
    cairo
    cups
    dbus
    expat
    gdk-pixbuf
    glib
    graphite2
    gtk3
    libdrm
    libgbm
    libGL
    libnotify
    libsecret
    libusb1
    libX11
    libxcb
    libXcomposite
    libXdamage
    libXext
    libXfixes
    libxkbcommon
    libXrandr
    libxshmfence
    nspr
    nss
    openssl
    pango
    stdenv.cc.cc.lib
    udev
    vulkan-loader
  ];
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "chatgpt";
  version = "26.803.81509";

  src = fetchurl {
    url = "https://persistent.oaistatic.com/codex-app-prod/linux/deb/latest/chatgpt_amd64.deb";
    hash = "sha256-qb+Ro2j598Tuo4CCqfuPtGuNAFtxmm13FdLloZgsOOs=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    dpkg
    imagemagick
    makeWrapper
  ];

  buildInputs = runtimeLibs;

  unpackPhase = ''
    runHook preUnpack
    dpkg-deb -x "$src" .
    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/lib" "$out/bin" "$out/share/applications"
    cp -a usr/lib/chatgpt "$out/lib/"

    install -Dm644 usr/share/applications/chatgpt.desktop \
      "$out/share/applications/chatgpt.desktop"
    mkdir -p "$out/share/icons/hicolor/512x512/apps"
    magick "$out/lib/chatgpt/resources/icon-chatgpt.png" \
      -resize 512x512 \
      "$out/share/icons/hicolor/512x512/apps/chatgpt.png"

    makeWrapper "$out/lib/chatgpt/ChatGPT" "$out/bin/chatgpt" \
      --prefix PATH : "${lib.makeBinPath [ xdg-utils ]}" \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath runtimeLibs}" \
      --add-flags "--no-sandbox"

    runHook postInstall
  '';

  autoPatchelfIgnoreMissingDeps = [
    "libQt5Core.so.5"
    "libQt5Gui.so.5"
    "libQt5Widgets.so.5"
    "libQt6Core.so.6"
    "libQt6Gui.so.6"
    "libQt6Widgets.so.6"
    "libc.musl-x86_64.so.1"
  ];

  meta = {
    description = "ChatGPT desktop application by OpenAI";
    homepage = "https://developers.openai.com/codex/app";
    license = lib.licenses.unfree;
    mainProgram = "chatgpt";
    platforms = [ "x86_64-linux" ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
})
