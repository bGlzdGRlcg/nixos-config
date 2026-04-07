{ lib, fetchFromGitHub, callPackage }:

let
  version = "unstable-dda6a6d";

  src = fetchFromGitHub {
    owner = "shenmintao";
    repo = "aic8800d80";
    rev = "05710dff05dabce66ab3ee80f40484892c512b3c";
    hash = "sha256-QVpuJrCssBf4fwycq7oN0Oi9OxpQUqrSTQuHk5UE9+U=";
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
