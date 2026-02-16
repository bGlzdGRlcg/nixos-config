{ lib, fetchFromGitHub, callPackage }:

let
  version = "unstable-3a0945b";

  src = fetchFromGitHub {
    owner = "shenmintao";
    repo = "aic8800d80";
    rev = "3a0945bdcc94dd15402b8e133f5cf53b9ace7ed6";
    hash = "sha256-6ihWPLbYf/D3QcK1jAEzvox69mf5XCJAeJe/fpiQOGM=";
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
