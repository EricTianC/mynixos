# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ lib, config, mihomosh, pkgs, ... }:
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  networking.proxy.default = "http://127.0.0.1:7890";
  networking.proxy.noProxy = "127.0.0.1,localhost,::1,internal.domain";

  # Enable OpenGL
  hardware.graphics = {
    enable = true;
  };

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;

    nvidiaSettings = true;

    package = config.boot.kernelPackages.nvidiaPackages.stable;

    prime = {
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };


  # Set your time zone.
  time.timeZone = "Asia/Shanghai";

  # Select internationalisation properties.
  i18n.defaultLocale = "zh_CN.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "zh_CN.UTF-8";
    LC_IDENTIFICATION = "zh_CN.UTF-8";
    LC_MEASUREMENT = "zh_CN.UTF-8";
    LC_MONETARY = "zh_CN.UTF-8";
    LC_NAME = "zh_CN.UTF-8";
    LC_NUMERIC = "zh_CN.UTF-8";
    LC_PAPER = "zh_CN.UTF-8";
    LC_TELEPHONE = "zh_CN.UTF-8";
    LC_TIME = "zh_CN.UTF-8";
  };

  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      waylandFrontend = true;
      addons = with pkgs; [
        qt6Packages.fcitx5-chinese-addons
        fcitx5-rime
      	fcitx5-gtk
        fcitx5-mozc
      ];
    };
  };

  # Enable the X11 windowing system.
  # services.xserver.enable = true;
  # services.displayManager.sddm = {
  #   enable = true;
  #   wayland.enable = true;
  # };
  services.greetd = {
    enable = true;
    settings = {
       default_session = {
         command = ''
           ${lib.getExe pkgs.tuigreet} \
           --sessions ${config.services.displayManager.sessionData.desktops}/share/wayland-sessions \
           --time \
           --time-format '%Y-%m-%d %H:%M' \
           --asterisks \
           --remember \
           --remember-session
         '';
       };
    #   default_session = {
    #     command = "${pkgs.cage}/bin/cage -s -- ${pkgs.wlgreet}/bin/wlgreet --command niri";
    #   };
    };
  };

  # Enable the GNOME Desktop Environment.
  # services.displayManager.gdm.enable = true;
  # services.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "cn";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  services.mihomo = {
    enable = true;
    tunMode = true;
    configFile = "/var/lib/mihomo/config.yaml";
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.tyllm = {
    isNormalUser = true;
    description = "tyllm";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      brightnessctl
    #  thunderbird
    ];
    # shell = pkgs.zsh;
  };

  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    xwayland-satellite
    cava
    yazi
    wl-clipboard
    mihomosh.packages.x86_64-linux.default
    distrobox
    pulseaudioFull

    uv
    # wlgreet
  ];

  programs.nix-ld.enable = true;

  programs.git = {
    enable = true;
    config = {
      init.defaultBranch = "main";
    };
  };

  programs.gnupg.agent = {
    enable = true;
    pinentryPackage = with pkgs; pinentry-qt;
    enableSSHSupport = true;
  };

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting # Disable greeting
    '';
  };

  programs.nixvim = {
    enable = true;

    colorschemes.catppuccin = {
      enable = true;
    };

    globals.mapleader = "<space>";
    # globals.maplocalleader = "<space><space>";

    opts = {
      tabstop = 2;
      shiftwidth = 2;
      expandtab = true;

      number = true;
      relativenumber = true;

      foldcolumn = "auto";
      foldlevel = 99;
      foldlevelstart = 99;
      foldenable = true;

      fillchars = {
				eob = " ";
				fold = " ";
				foldopen = "";
				foldsep = " ";
				# foldinner = " ";
				foldclose = "";
			};
      
    };

    clipboard = {
      register = "unnamedplus";
      providers = {
        wl-copy.enable = true;
      };
    };

    plugins = {
      web-devicons.enable = true;
      statuscol = {
        enable = true;
        settings = {
          bt_ignore = null;
          clickhandlers = {
            FoldClose = "require('statuscol.builtin').foldclose_click";
            FoldOpen = "require('statuscol.builtin').foldopen_click";
            FoldOther = "require('statuscol.builtin').foldother_click";
            Lnum = "require('statuscol.builtin').lnum_click";
          };
          clickmod = "c";
          ft_ignore = null;
          relculright = true;
          segments = [
            {
              click = "v:lua.ScFa";
              text = [
                "%C"
              ];
            }
            {
              click = "v:lua.ScSa";
              text = [
                "%s"
              ];
            }
            {
              click = "v:lua.ScLa";
              condition = [
                true
                {
                  __raw = "require('statuscol.builtin').not_empty";
                }
              ];
              text = [
                {
                  __raw = "require('statuscol.builtin').lnumfunc";
                }
                " "
              ];
            }
          ];
          setopt = true;
          thousands = ".";
        };
      };
      nvim-ufo.enable = true;
      treesitter = {
        enable = true;
        highlight.enable = true;
        indent.enable = true;
        folding.enable = true;
      };
      treesitter-textobjects = {
        enable = true;
        settings = {
          enable = true;
          lookahead = true;
          keymaps = {
            aa = "@parameter.outer";
            ab = "@block.outer";
            ac = "@call.outer";
            ia = "@parameter.inner";
            ib = "@block.inner";
            ic = "@call.inner";
          };
        };
      };
      lualine.enable = true;
      nvim-tree.enable = true;
      telescope.enable = true;
      flash.enable = true;
      noice.enable = true;
      bufferline.enable = true;
      toggleterm = {
        enable = true;
        settings = {
          open_mapping = "[[<c-\\>]]";
          shell = "fish";
        };
      };
      lsp-format = {
        enable = true;
      };
      lsp = {
        enable = true;
        inlayHints = true;
        servers = {
          nixd = {
            enable = true;
          };
          clangd = {
            enable = true;
            package = null;
          };
          zls = {
            enable = true;
            package = null;
          };
        };
      };
      cmp = {
        enable = true;
        autoEnableSources = true;
        settings.sources = [
          { name = "luasnip"; }
          { name = "nvim_lsp"; }
          { name = "path"; }
          { name = "buffer"; }
        ];
        settings.mapping = {
          "<CR>" = "cmp.mapping.confirm({ select = true })";
        };
        settings.snippet = {
          expand = "function(args) require('luasnip').lsp_expand(args.body) end";
        };
      };
      dap = {
        enable = true;
      };
      luasnip = {
        enable = true;
        fromVscode = [
          {lazyLoad = true;}
        ];
      };
      lean = {
        enable = true;
        settings = {
          mapping = true;
          abbreviations = {
            enable = true;
          };
          lsp = {
            enable = true;
          };
          infoview = {
            autoopen = true;
            orientation = "auto";
            indicators = "auto";
          };
        };
      };
      flutter-tools = {
        enable = true;
      };
      vimtex = {
        enable = true;
        texlivePackage = null;
        settings = {
          view_method = "zathura";
        };
      };
      cmp-vimtex.enable = true;
    # snacks.enable = true;
    };

    dependencies = {
      fd.enable = true;
      lean = {
        enable = true;
        packageFallback = true;
      };
      flutter = {
        enable = false;
        package = null;
      };
    };
  };

  # programs.clash-verge.enable = true;
  # programs.zsh.enable = true;
  # programs.zsh.enableGlobalCompInit = false;

  programs.niri.enable = true;

  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
      fira-code
      fira-code-symbols
      font-awesome
      ubuntu-classic
      maple-mono.truetype
      maple-mono.NF-unhinted
      maple-mono.NF-CN-unhinted
      maple-mono.truetype-autohint
      maple-mono.NF
      maple-mono.NF-CN
      nerd-fonts.jetbrains-mono
      nerd-fonts.martian-mono
    ];
    
    fontconfig = {
      defaultFonts = {
        monospace = [
          "Noto Sans Mono CJK SC"
        ];
        sansSerif = [
          "Noto Sans CJK SC"
        ];
        serif = [ "Noto Serif CJK SC" ]; 
      }; 
    };
  };

  # # black screen
  # programs.steam = {
  #   enable = true;
  #   remotePlay.openFirewall = true;
  #   dedicatedServer.openFirewall = true;
  #   localNetworkGameTransfers.openFirewall = true;
  # };
  services.deluge = {
    enable = true;
    web.enable = true;
  };


  environment.variables = {
    # GTK_IM_MODULE = lib.mkForce null;
    # QT_IM_MODULE = "fcitx";
    # XMODIFIERS = "@im=fcitx";
    EDITOR = "nvim";
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;
  services.earlyoom.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?
  
  nix.settings = {
    substituters = [
      # "https://mirrors.ustc.edu.cn/nix-channels/store"
      # "https://mirrors.cernet.edu.cn/nix-channels/store"
    ];
  };
  nix.settings.trusted-users = [ "root" "tyllm" "@wheel" ];
}
