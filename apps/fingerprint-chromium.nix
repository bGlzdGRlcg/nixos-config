{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  makeWrapper,
  wrapGAppsHook3,
  copyDesktopItems,
  makeDesktopItem,
  glib,
  gtk3,
  nss,
  nspr,
  atk,
  at-spi2-atk,
  at-spi2-core,
  cairo,
  pango,
  gdk-pixbuf,
  dbus,
  cups,
  libX11,
  libXcomposite,
  libXdamage,
  libXext,
  libXfixes,
  libXrandr,
  libXrender,
  libXtst,
  libXi,
  libXcursor,
  libXScrnSaver,
  libxcb,
  libxkbcommon,
  libxshmfence,
  mesa,
  libgbm,
  libdrm,
  vulkan-loader,
  alsa-lib,
  expat,
  systemd,
  libGL,
  libsecret,
  fontconfig,
  freetype,
}:
let
  runtimeLibs = [
    glib
    gtk3
    nss
    nspr
    atk
    at-spi2-atk
    at-spi2-core
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
    libXrender
    libXtst
    libXi
    libXcursor
    libXScrnSaver
    libxcb
    libxkbcommon
    libxshmfence
    mesa
    libgbm
    libdrm
    vulkan-loader
    alsa-lib
    expat
    systemd
    libGL
    libsecret
    fontconfig
    freetype
    stdenv.cc.cc.lib
  ];
in
stdenv.mkDerivation rec {
  pname = "fingerprint-chromium";
  version = "144.0.7559.132";

  src = fetchurl {
    url = "https://github.com/adryfish/fingerprint-chromium/releases/download/${version}/ungoogled-chromium-${version}-1-x86_64_linux.tar.xz";
    hash = "sha256-u0xEhAuufogfYljtWzP5cvKEOE2Ji2KJ4fDAv0dVXt4=";
  };

  sourceRoot = "ungoogled-chromium-${version}-1-x86_64_linux";

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
    wrapGAppsHook3
    copyDesktopItems
  ];

  buildInputs = runtimeLibs;

  dontWrapGApps = true;

  autoPatchelfIgnoreMissingDeps = [
    "libQt5Core.so.5"
    "libQt5Gui.so.5"
    "libQt5Widgets.so.5"
    "libQt6Core.so.6"
    "libQt6Gui.so.6"
    "libQt6Widgets.so.6"
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "fingerprint-chromium";
      desktopName = "Fingerprint Chromium";
      genericName = "Web Browser";
      comment = "Anti-fingerprint Chromium browser";
      exec = "chrome %U";
      icon = "fingerprint-chromium";
      categories = [
        "Network"
        "WebBrowser"
      ];
      mimeTypes = [
        "text/html"
        "text/xml"
        "application/xhtml+xml"
        "x-scheme-handler/http"
        "x-scheme-handler/https"
      ];
      startupWMClass = "fingerprint-chromium";
      terminal = false;
    })
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/opt/fingerprint-chromium $out/bin
    cp -r ./* $out/opt/fingerprint-chromium/

    chmod +x $out/opt/fingerprint-chromium/chrome

    makeWrapper $out/opt/fingerprint-chromium/chrome $out/bin/chrome \
      "''${gappsWrapperArgs[@]}" \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath runtimeLibs} \
      --add-flags "--no-sandbox" \
      --add-flags "--ozone-platform-hint=auto" \
      --add-flags "--enable-features=UseOzonePlatform,WaylandWindowDecorations" \
      --add-flags "--force-device-scale-factor=1"

    mkdir -p $out/share/icons/hicolor/48x48/apps
    cp $out/opt/fingerprint-chromium/product_logo_48.png \
      $out/share/icons/hicolor/48x48/apps/fingerprint-chromium.png

    runHook postInstall
  '';

  meta = with lib; {
    description = "Anti-fingerprint Chromium browser based on ungoogled-chromium";
    homepage = "https://github.com/adryfish/fingerprint-chromium";
    sourceProvenance = [ sourceTypes.binaryNativeCode ];
    license = licenses.bsd3;
    platforms = [ "x86_64-linux" ];
    mainProgram = "chrome";
    maintainers = [ ];
  };
}
