{
  stdenv,
  kernel,
  version,
  src,
  commonMeta,
}:

stdenv.mkDerivation {
  pname = "aic8800d80-module";
  version = "${version}-${kernel.modDirVersion}";

  inherit src;
  nativeBuildInputs = kernel.moduleBuildDependencies;

  makeFlags = [
    "-C"
    "drivers/aic8800"
    "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "KVER=${kernel.modDirVersion}"
    "ARCH=${stdenv.hostPlatform.linuxArch}"
  ];

  enableParallelBuilding = true;

  installPhase = ''
    runHook preInstall

    modDir="$out/lib/modules/${kernel.modDirVersion}/kernel/drivers/net/wireless/aic8800"
    install -Dm644 drivers/aic8800/aic_load_fw/aic_load_fw.ko "$modDir/aic_load_fw.ko"
    install -Dm644 drivers/aic8800/aic8800_fdrv/aic8800_fdrv.ko "$modDir/aic8800_fdrv.ko"

    runHook postInstall
  '';

  meta = commonMeta // {
    description = "AIC8800D80 Modules";
  };
}
