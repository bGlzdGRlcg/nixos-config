{ pkgs, ... }:

{
  programs = {
    fish = {
      enable = true;
      shellAliases = {
        rm = "safe-rm";
      };
    };
    gnupg.agent.enable = true;
    steam.enable = true;

    nix-ld = {
      enable = true;
      libraries = with pkgs; [
        zlib
        zstd
        stdenv.cc.cc
        curl
        openssl
        attr
        libssh
        bzip2
        libxml2
        acl
        libsodium
        util-linux
        xz
        systemd
        vulkan-loader
        vulkan-headers
        mesa
      ];
    };

    virt-manager.enable = true;
  };
}
