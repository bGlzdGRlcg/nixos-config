{ lib, fetchFromGitHub, callPackage }:

let
  version = "unstable-3f9916b";

  src = fetchFromGitHub {
    owner = "shenmintao";
    repo = "aic8800d80";
    rev = "3f9916b6ff63131918712a4b883a1d6dd98804ce";
    hash = "sha256-uRHafdxDqJm7kV6lvWQurVNNRBXz5yrB9AXwEDfik7I=";
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
