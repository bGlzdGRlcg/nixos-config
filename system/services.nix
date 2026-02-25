{ pkgs, ... }:

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
        WIFI_IFACE="wlan0";
        CHANNEL=36;
        USE_PSK=0;
        SSID="popipa";
        PASSPHRASE="ciallo0721";
        GATEWAY="192.168.12.1";
        WPA_VERSION=2;
        HIDDEN=0;
        IEEE80211N=1;
        IEEE80211AC=1;
        IEEE80211AX=1;
        HT_CAPAB="[HT40+]";
        VHT_CAPAB="[SHORT-GI-80][MAX-MP-PD-128]";
        NO_VIRT=1;
        COUNTRY="CN";
        FREQ_BAND=5;
      };
    };

    aria2 = {
      enable = true;
      settings = {
        dir = "/home/listder/Downloads";
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
      package = pkgs.sunshine.override {
        boost = pkgs.boost187;
      };
    };
  };
}
