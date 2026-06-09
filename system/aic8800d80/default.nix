{ lib, fetchFromGitHub, callPackage }:

let
  version = "unstable-a5db07c";

  src = fetchFromGitHub {
    owner = "shenmintao";
    repo = "aic8800d80";
    rev = "a5db07c4d43fd0099bf90784b9295984cc22a310";
    hash = "sha256-KyniKjCZFmbGCi7K7RaeXOtoZhxwaW//WoML4r7vpGM=";
  };

  commonMeta = {
    homepage = "https://github.com/shenmintao/aic8800d80";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
  };
in
{
  firmware = callPackage ./firmware.nix {
    inherit version src commonMeta;
  };

  mkModule =
    kernelPackages:
    kernelPackages.callPackage ./module.nix {
      inherit version src commonMeta;
      kernel = kernelPackages.kernel;
    };
}
