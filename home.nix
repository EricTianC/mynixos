{ config, pkgs, ...}:
{
  home.username = "tyllm";
  home.homeDirectory = "/home/tyllm";

  home.packages = with pkgs;[
    fastfetch
    swaybg
  ];
  
  programs.git = {
    enable = true;
    settings.user = {
      name = "Eric Tian";
      email = "EricTianC@outlook.com";
    };
  };

  programs.neovim = {
    enable = true;
  };

  # programs.yazi.enable = true; # file manager
  programs.kitty = {
    enable = true;
    font = with pkgs;{
      name = "Maple Mono";
      package = maple-mono.truetype;
    };
    themeFile = "YsDark";
  };

  programs.fuzzel.enable = true;
  programs.swaylock.enable = true;
  programs.waybar.enable = true;
  services.mako.enable = true;
  services.swayidle.enable = true;
  services.polkit-gnome.enable = true;

  # xdg.configFile."waybar/config.jsonc".source = ./configs/waybar/config.jsonc;

  home.stateVersion = "25.11";
}
