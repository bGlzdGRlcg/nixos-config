{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot = {
    initrd = {
      availableKernelModules = [
        "xhci_pci"
        "thunderbolt"
        "vmd"
        "nvme"
        "usbhid"
        "usb_storage"
        "sr_mod"
      ];
      kernelModules = [ ];
    };
    loader = {
      grub = {
        theme = "${pkgs.minimal-grub-theme}";
        enable = true;
        efiSupport = true;
        configurationLimit = 5;
        device = "nodev";
      };
      efi = {
        canTouchEfiVariables = true;
      };
    };
    kernelModules = [ "kvm-intel" ];
    extraModulePackages = [ ];
    kernelPackages = pkgs.linuxKernel.packages.linux_zen;
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/2ead3d3d-8708-430b-b8f2-31f8fbdddc1b";
      fsType = "btrfs";
      options = [
        "subvol=root"
        "compress=zstd"
      ];
    };
    "/home" = {
      device = "/dev/disk/by-uuid/2ead3d3d-8708-430b-b8f2-31f8fbdddc1b";
      fsType = "btrfs";
      options = [
        "subvol=home"
        "compress=zstd"
      ];
    };
    "/nix" = {
      device = "/dev/disk/by-uuid/2ead3d3d-8708-430b-b8f2-31f8fbdddc1b";
      fsType = "btrfs";
      options = [
        "subvol=nix"
        "noatime"
        "compress=zstd"
      ];
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/16AE-CB1C";
      fsType = "vfat";
      options = [
        "fmask=0022"
        "dmask=0022"
      ];
    };
  };

  swapDevices = [ { device = "/dev/disk/by-uuid/3e6eff8e-96e2-4be0-99f2-8b9db88988d2"; } ];

  networking = {
    hostName = "listder";
    networkmanager.enable = true;
    firewall.enable = false;
  };

  networking.useDHCP = lib.mkDefault true;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
