{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:

let
  aic8800d80 = pkgs.callPackage ./aic8800d80 { };
  aic8800d80Firmware = aic8800d80.firmware;
  aic8800d80Module = aic8800d80.mkModule config.boot.kernelPackages;
in
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
      kernelModules = [
        "vfio_pci"
        "vfio"
        "vfio_iommu_type1"
      ];
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
    kernelModules = [
      "kvm-intel"
      "aic_load_fw"
      "aic8800_fdrv"
    ];
    kernelParams = [
      "intel_iommu=on"
      "intel_pstate=active"
      "intel_idle.max_cstate=1"
      "zswap.enabled=1"
      "zswap.compressor=zstd"
      "zswap.max_pool_percent=20"
    ];
    extraModprobeConfig = ''
      options aic_load_fw aic_fw_path=/run/current-system/firmware/aic8800D80
      options aic8800_fdrv power_save=0
      options kvm_intel nested=1
    '';
    extraModulePackages = [ aic8800d80Module ];
    kernelPackages = pkgs.linuxKernel.packages.linux_zen;
    kernel.sysctl = {
      "net.core.default_qdisc" = "fq";
      "net.ipv4.tcp_congestion_control" = "bbr";
      "vm.swappiness" = 25;
    };
    binfmt.emulatedSystems = [
      "aarch64-linux"
      "riscv64-linux"
      "s390x-linux"
      "loongarch64-linux"
      "i686-windows"
      "x86_64-windows"
    ];
  };

  services.udev.packages = [ aic8800d80Firmware ];
  hardware = {
    firmware = [ aic8800d80Firmware ];
    graphics = {
      enable = true;
      enable32Bit = true;
    };
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
  zramSwap = {
    enable = true;
    memoryPercent = 25;
  };

  networking = {
    hostName = "listder";
    networkmanager = {
      enable = true;
      settings.keyfile.unmanaged-devices = "interface-name:wlan0";
    };
    firewall.enable = false;
  };

  networking.useDHCP = lib.mkDefault true;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
