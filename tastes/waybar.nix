{lib, pkgs, config, ...}:
{
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
  xdg.configFile."waybar".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/.config/waybar";
}
