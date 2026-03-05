{ lib, fetchFromGitHub, callPackage }:

let
  version = "unstable-dda6a6d";

  src = fetchFromGitHub {
    owner = "shenmintao";
    repo = "aic8800d80";
    rev = "dda6a6d546324786d802f452ef854aeea7b52af5";
    hash = "sha256-TD4qpTqu3D9PmygSOMLQgjyWJF8kqebKFd3TI57RfPY=";
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
