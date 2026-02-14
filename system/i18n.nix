{ pkgs, ... }:

{
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocales = [
      "en_US.UTF-8/UTF-8"
      "zh_CN.UTF-8/UTF-8"
    ];

    inputMethod = {
      enable = true;
      type = "fcitx5";
      fcitx5 = {
        addons = with pkgs.qt6Packages; [
          fcitx5-qt
          fcitx5-configtool
          fcitx5-chinese-addons
        ];
        waylandFrontend = true;
      };
    };
  };
}
