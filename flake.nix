{
  description = "listder's nixos flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.11";
  };

  nixConfig.experimental-features = [
    "nix-command"
    "flakes"
  ];

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-stable,
      ...
    }@inputs:
    {
      nixosConfigurations.listder = nixpkgs.lib.nixosSystem {
        specialArgs =
          let
            system = "x86_64-linux";
          in
          {
            pkgs-stable = import nixpkgs-stable {
              inherit system;
              config = {
                android_sdk.accept_license = true;
                allowUnfree = true;
              };
            };
          };
        modules = [
          ./system
          ./apps
          ./home
          ./programs
        ];
      };
    };
}
