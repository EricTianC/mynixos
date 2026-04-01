{ config, lib, pkgs, nullclaw, ...}:
let 
  nullclaw-pkg = nullclaw.packages.${pkgs.system}.default ;
in
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
    mathematica
    # nullclaw-pkg
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
  services.ssh-agent.enable = true;

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

  services.polkit-gnome.enable = true;

    # systemd.user.services.nullclaw = {
    #   Unit = {
    #     Description = "nullclaw gateway runtime";
    #     After = "network.targe";
    #   };
    #   Service = {
    #     Type = "simple";
    #     ExecStart = "${nullclaw-pkg}/bin/nullclaw gateway";
    #     Restart = "always";
    #     RestartSec = 3;
    #     EnvironmentFile="-/home/tyllm/.nullclaw/.env";
    #   };
    #   Install = {
    #     WantedBy = [ "default.target" ];
    #   };
    # };


  # xdg.configFile."swaylock/config".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/.config/swaylock/config";
  xdg.configFile."niri/config.kdl".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/.config/niri/config.kdl";

  home.stateVersion = "25.11";
}
