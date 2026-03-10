{ config, lib, pkgs, ...}:
{
  home.username = "tyllm";
  home.homeDirectory = "/home/tyllm";

  home.packages = with pkgs;[
    fastfetch
    swaybg
    qq
    wechat-uos
    # texliveFull
    (texliveFull.withPackages (ps: with ps; [ fandol texlive-scripts texlive-scripts-extra ]))
    ltspice
    sage
  ];

  home.pointerCursor = {
    gtk.enable = true;
    # 如果你也希望在 X11 应用程序中生效
    x11.enable = true;
    
    package = pkgs.kdePackages.breeze-icons; # 或者 pkgs.libsForQt5.breeze-qt5
    name = "breeze_cursors";
    size = 24;
  };

  # 确保 GTK 配置被启用
  gtk = {
    enable = true;
    cursorTheme = {
      package = pkgs.kdePackages.breeze-icons;
      name = "breeze_cursors";
    };
  };


  
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
      package = maple-mono.truetype-autohint;
    };
    themeFile = "YsDark";
    settings = {
      # cursor_trail = 500;
      hide_window_decorations = "yes";
    };
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
  catppuccin.fuzzel.enable = true;


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

  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        font = "Ubuntu Mono";
      };
    };
  };
  programs.swaylock = {
    enable = true;
    package = pkgs.swaylock-effects;
    settings = {
      screenshots = true;
      clock = true;
      indicator = true;
      indicator-radius = 100;
      indicator-thickness = 7;
      effect-blur = "7x5";
      effect-vignette = "0.5:0.5";
      ring-color = "bb00cc";
      key-hl-color = "880033";
      line-color = "00000000";
      inside-color = "00000088";
      separator-color = "00000000";
      grace = 2;
      fade-in = 0.2;
    };
  };
  programs.waybar.enable = true;
  services.ssh-agent.enable = true;
  services.mako.enable = true;
  services.swayidle = 
  let
    lock = "${pkgs.swaylock-effects}/bin/swaylock --daemonize";
    display = status: "${pkgs.niri}/bin/niri msg action power-${status}-monitors";
  in
  {
    enable = true;
    timeouts = [
      {
        timeout = 150;
        command = "${pkgs.libnotify}/bin/notify-send 'Locking in 30 seconds' -t 30000";
      }
      {
        timeout = 200;
        command = lock;
      }
      {
        timeout = 250;
        command = display "off";
        resumeCommand = display "on";
      }
      {
        timeout = 300;
        command = "${pkgs.systemd}/bin/systemctl suspend";
      }
    ];
    events = [
      {
        event = "before-sleep";
        command = (display "off") + "; " + lock;
      }
      {
        event = "after-resume";
        command = display "on";
      }
      {
        event = "lock";
        command = (display "off") + "; " + lock;
      }
      {
        event = "unlock";
        command = display "on";
      }
    ];
  };
  services.polkit-gnome.enable = true;

  xdg.configFile."waybar".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/.config/waybar";
  # xdg.configFile."swaylock/config".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/.config/swaylock/config";
  xdg.configFile."niri/config.kdl".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/.config/niri/config.kdl";

  home.stateVersion = "25.11";
}
