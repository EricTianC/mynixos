{ config, lib, pkgs, ...}:
{
  home.username = "tyllm";
  home.homeDirectory = "/home/tyllm";

  home.packages = with pkgs;[
    fastfetch
    swaybg
    qq
  ];
  
  programs.git = {
    enable = true;
    settings.user = {
      name = "Eric Tian";
      email = "EricTianC@outlook.com";
    };
  };

  # programs.neovim = {
  #   enable = true;
  # };

  # programs.yazi.enable = true; # file manager
  programs.kitty = {
    enable = true;
    font = with pkgs;{
      name = "Maple Mono";
      package = maple-mono.truetype;
    };
    themeFile = "YsDark";
    # settings = {
    #   cursor_trail = 500;
    # };
  };

  programs.fish = {
    enable = true;

    plugins = [
      { 
        name = "tide";
        src = pkgs.fishPlugins.tide.src;
      }
    ];
  };

  catppuccin.fish.enable = true;


  # programs.zsh = {
  #   enable = true;
  #   enableCompletion = true;
  #   # autosuggestion.enable = true;
  #   syntaxHighlighting.enable = true;

  #   # oh-my-zsh.enable = true;

  #   # initContent = let
  #   #   # zconfEarly = lib.mkBefore ''
  #   #   #   export PROFILING_MODE=0
  #   #   #   if [ $PROFILING_MODE -ne 0 ]; then
  #   #   #     zmodload zsh/zprof
  #   #   #   fi
  #   #   # '';
  #   #   # zconfAfter = lib.mkAfter ''
  #   #   #   if [ $PROFILING_MODE -ne 0 ]; then
  #   #   #     zprof
  #   #   #   fi
  #   #   # '';
  #   #   zconfEarly = lib.mkBefore "zmodload zsh/zprof";
  #   #   zconfAfter = lib.mkAfter "zprof";
  #   # in lib.mkMerge [zconfEarly zconfAfter];
  # };

  programs.fuzzel.enable = true;
  programs.swaylock = {
    enable = true;
    settings = {
      screenshots = true;
      clock = true;
    };
  };
  programs.waybar.enable = true;
  services.mako.enable = true;
  services.swayidle.enable = true;
  services.polkit-gnome.enable = true;

  xdg.configFile."waybar/config".source = ./dotfiles/.config/waybar/config;
  xdg.configFile."waybar/style.css".source = ./dotfiles/.config/waybar/style.css;
  xdg.configFile."swaylock/config".source = ./dotfiles/.config/swaylock/config;

  home.stateVersion = "25.11";
}
