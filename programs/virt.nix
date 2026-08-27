{ pkgs, ... }:
{
  virtualisation = {
    containers.registries.settings.registries.search.registries = [
      "docker.io"
      "quay.io"
    ];
    podman = {
      enable = true;
      dockerCompat = true;
    };
    libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = true;
        swtpm.enable = true;
        vhostUserPackages = with pkgs; [ virtiofsd ];
      };
    };
    spiceUSBRedirection.enable = true;
    # waydroid = {
    #     enable = true;
    #     package = pkgs.waydroid-nftables;
    # };
  };
}
