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
  };
}
