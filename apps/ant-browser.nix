{
  lib,
  stdenv,
  fetchurl,
  runCommand,
  autoPatchelfHook,
  makeWrapper,
  copyDesktopItems,
  makeDesktopItem,
  glib,
  gtk3,
  webkitgtk_4_1,
  gdk-pixbuf,
  cairo,
  pango,
  harfbuzz,
  at-spi2-atk,
}:
let
  webkitCompat = runCommand "webkitgtk-4.0-compat" { } ''
    mkdir -p $out/lib
    ln -s ${webkitgtk_4_1}/lib/libwebkit2gtk-4.1.so.0 $out/lib/libwebkit2gtk-4.0.so.37
    ln -s ${webkitgtk_4_1}/lib/libjavascriptcoregtk-4.1.so.0 $out/lib/libjavascriptcoregtk-4.0.so.18
  '';

  runtimeLibs = [
    glib
    gtk3
    webkitgtk_4_1
    webkitCompat
    gdk-pixbuf
    cairo
    pango
    harfbuzz
    at-spi2-atk
  ];
in
stdenv.mkDerivation rec {
  pname = "ant-browser";
  version = "1.2.0";

  src = fetchurl {
    url = "https://github.com/black-ant/Ant-Browser/releases/download/V${version}/AntBrowser-${version}-linux-amd64.tar.gz";
    hash = "sha256-obZ9tg+iOMGKmJLf/xoaEMQIwnDZe+p5WBnd52Y4mdg=";
  };

  sourceRoot = ".";

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
    copyDesktopItems
  ];

  buildInputs = runtimeLibs;

  desktopItems = [
    (makeDesktopItem {
      name = "ant-browser";
      desktopName = "Ant Browser";
      genericName = "Fingerprint Browser Manager";
      comment = "Manage isolated browser instances with proxy binding";
      exec = "ant-browser";
      icon = "ant-browser";
      categories = [
        "Network"
        "Utility"
      ];
      startupWMClass = "ant-chrome";
      terminal = false;
    })
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/opt/ant-browser $out/bin
    cp -r ./* $out/opt/ant-browser/

    chmod +x $out/opt/ant-browser/ant-chrome
    chmod +x $out/opt/ant-browser/bin/sing-box $out/opt/ant-browser/bin/xray

    makeWrapper $out/opt/ant-browser/ant-chrome $out/bin/ant-browser \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath runtimeLibs} \
      --set GDK_BACKEND x11 \
      --chdir $out/opt/ant-browser

    runHook postInstall
  '';

  meta = with lib; {
    description = "Desktop fingerprint browser manager for multi-account isolation and proxy binding";
    homepage = "https://github.com/black-ant/Ant-Browser";
    sourceProvenance = [ sourceTypes.binaryNativeCode ];
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    mainProgram = "ant-browser";
    maintainers = [ ];
  };
}
