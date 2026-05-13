{
  lib,
  stdenvNoCC,
  util-linux,
  version,
  src,
  commonMeta,
}:

stdenvNoCC.mkDerivation {
  pname = "aic8800d80-firmware";
  inherit version src;

  compressFirmware = false;
  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    install -Dm644 aic.rules "$out/lib/udev/rules.d/aic.rules"
    substituteInPlace "$out/lib/udev/rules.d/aic.rules" \
      --replace-fail "/usr/bin/eject" "${lib.getExe' util-linux "eject"}"

    mkdir -p "$out/lib/firmware"
    cp -r fw/aic8800D80 "$out/lib/firmware/"
    ln -sfn . "$out/lib/firmware/aic8800D80/aic8800D80"

    runHook postInstall
  '';

  meta = commonMeta // {
    description = "AIC8800D80 Firmware";
  };
}
