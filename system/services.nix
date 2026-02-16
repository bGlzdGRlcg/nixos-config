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

    dae = {
      configFile = "/etc/dae/config.dae";
      enable = true;
    };

    openssh = {
      enable = true;
      settings = {
        X11Forwarding = true;
        PermitRootLogin = "yes";
        PasswordAuthentication = true;
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
    };
  };
}
