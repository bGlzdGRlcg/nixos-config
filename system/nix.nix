{ pkgs, ... }:

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
  nixpkgs.config = {
    android_sdk.accept_license = true;
    allowUnfree = true;
  };
  time.timeZone = "Asia/Shanghai";
  system.stateVersion = "25.11";
}
