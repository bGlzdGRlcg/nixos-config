{ lib, fetchFromGitHub, callPackage }:

let
  version = "unstable-f8df5e7";

  src = fetchFromGitHub {
    owner = "shenmintao";
    repo = "aic8800d80";
    rev = "f8df5e741e24656fcd8e5d309e417f675cdcc5d0";
    hash = "sha256-a06YBX82bov5pu5Byhvx7BRAQMNm6QZGW/44AnWqwMc=";
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
