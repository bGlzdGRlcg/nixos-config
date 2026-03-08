{ pkgs, lib, ... }:

{
  services = {
    fprintd.enable = true;
    xserver = {
      videoDrivers = [ "modesetting" ];
      enable = true;
      xkb = {
        layout = "us";
        variant = "";
      };
    };

    displayManager.sddm = {
      enable = true;
      theme = "${pkgs.where-is-my-sddm-theme}/share/sddm/themes/where_is_my_sddm_theme";
    };
    desktopManager.plasma6.enable = true;
    pulseaudio.enable = false;

    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
    };

    # dae = {
    #   configFile = "/etc/dae/config.dae";
    #   enable = true;
    # };

    mihomo = {
      enable = true;
      tunMode = true;
      webui = "/var/lib/private/mihomo/zashboard/";
      configFile = "/etc/mihomo/config.yaml";
    };

    openssh = {
      enable = true;
      settings = {
        X11Forwarding = true;
        PermitRootLogin = "yes";
        PasswordAuthentication = true;
      };
    };

    create_ap = {
      enable = true;
      settings = {
        INTERNET_IFACE = "Meta";
        WIFI_IFACE = "wlan0";
        CHANNEL = 48;
        USE_PSK = 0;
        SSID = "popipa";
        PASSPHRASE = "ciallo0721";
        GATEWAY = "192.168.12.1";
        WPA_VERSION = 2;
        HIDDEN = 0;
        IEEE80211N = 1;
        IEEE80211AC = 1;
        IEEE80211AX = 1;
        HT_CAPAB = "[HT40-][SHORT-GI-20][SHORT-GI-40]";
        NO_VIRT = 1;
        COUNTRY = "CN";
        FREQ_BAND = 5;
      };
    };

    aria2 = {
      enable = true;
      settings = {
        dir = "/var/lib/aria2/Downloads/";
        continue = true;
        user-agent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/134.0.7117.93 Safari/537.36";
        always-resume = true;
        check-integrity = true;
        min-split-size = "10M";
        split = 64;
        max-concurrent-downloads = 3;
        max-connection-per-server = 16;
        connect-timeout = 120;
      };
      rpcSecretFile = "/etc/nixos/secrets/aria2-rpc-token.txt";
      openPorts = true;
    };

    sunshine = {
      enable = true;
      autoStart = true;
      capSysAdmin = true;
      openFirewall = true;
      # package = pkgs.sunshine.override {
      #   boost = pkgs.boost187;
      # };
    };

    samba = {
      enable = true;
      settings = {
        global = {
          "workgroup" = "WORKGROUP";
          "server string" = "smbnix";
          "netbios name" = "smbnix";
          "security" = "user";
          "hosts allow" = "192.168. 127.0.0.1 localhost";
          "hosts deny" = "0.0.0.0/0";
        };
        "windows" = {
          "path" = "/run/media/listder/listder/Windows";
          "browseable" = "yes";
          "read only" = "no";
          "guest ok" = "yes";
          "create mask" = "0644";
          "directory mask" = "0755";
        };
      };
    };

    asusd.enable = true;
    haveged.enable = true;
    qemuGuest.enable = true;
  };

  systemd.services = {
    wifi-tuning = {
      description = "WiFi tuning";
      after = [
        "network.target"
        "create_ap.service"
      ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Type = "oneshot";
      };

      script = ''
        ${pkgs.iw}/bin/iw dev wlan0 set power_save off || true
        ${pkgs.iw}/bin/iw dev wlan0 set txpower fixed 2000 || true
      '';
    };

    create_ap = {
      after = [
        "mihomo.service"
        "network-online.target"
      ];
      wants = [
        "mihomo.service"
        "network-online.target"
      ];
      requires = [ "mihomo.service" ];
      preStart = ''
        for i in $(seq 1 50); do
          if ${pkgs.iproute2}/bin/ip link show Meta >/dev/null 2>&1; then
            exit 0
          fi
          sleep 0.2
        done
        exit 1
      '';
    };

    virt-secret-init-encryption.serviceConfig.ExecStart = lib.mkForce [
      ""
      "${pkgs.runtimeShell} -c 'umask 0077 && (${pkgs.coreutils}/bin/dd if=/dev/random status=none bs=32 count=1 | ${pkgs.systemd}/bin/systemd-creds encrypt --name=secrets-encryption-key - /var/lib/libvirt/secrets/secrets-encryption-key)'"
    ];
  };
}
