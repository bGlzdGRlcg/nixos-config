{ ... }:

{
  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      auto-optimise-store = true;
    };
    gc = {
      automatic = true;
      options = "--delete-older-than 5d";
      dates = "daily";
    };
  };
  nixpkgs = {
    config = {
      android_sdk.accept_license = true;
      allowUnfree = true;
      permittedInsecurePackages = [
        "pnpm-10.29.2"
      ];
    };
  };
  time.timeZone = "Asia/Shanghai";
  system.stateVersion = "25.11";
}
