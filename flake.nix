{
  description = "my simple NixOS flake";

  nixConfig = {
    extra-substituters = [ "https://noctalia.cachix.org" ];
    extra-trusted-public-keys = [ "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4=" ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    # nixpkgs.url = "git+https://mirrors.tuna.tsinghua.edu.cn/git/nixpkgs.git?ref=nixos-25.11&shallow=1";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      # url = "github:nix-community/nixvim/nixos-25.11";
      url = "github:nix-community/nixvim";
      # inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia";
      # inputs.nixpkgs.follows = "nixpkgs";
    };
    noctalia-greeter = {
      url = "github:noctalia-dev/noctalia-greeter";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    eilmeldung = {
      url = "github:christo-auer/eilmeldung";
    };
    agenix.url = "github:ryantm/agenix";

    mihomosh.url = "path:./mihomosh";

    catppuccin.url = "github:catppuccin/nix/release-26.05";

    # nix-openclaw.url = "github:openclaw/nix-openclaw";
    nullclaw.url = "github:nullclaw/nullclaw";
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";
    hermes-agent.url = "github:NousResearch/hermes-agent";

    mooling-packages.url = "github:Mooling0602/nix-packages";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, sops-nix, nixvim, noctalia, noctalia-greeter, mihomosh, catppuccin,eilmeldung, agenix, nullclaw, nix-flatpak, hermes-agent, mooling-packages,... }@inputs: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      specialArgs = let 
          system = "x86_64-linux";
        in
        { 
          pkgs-unstable = import nixpkgs-unstable {
          inherit system;
          config.allowUnfree = true;
        };
        inherit mihomosh; inherit noctalia; inherit nullclaw; inherit noctalia-greeter; inherit mooling-packages;};
      modules = [
        ./configuration.nix
        sops-nix.nixosModules.sops

        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = let
              system = "x86_64-linux";
            in { 
              pkgs-unstable = import nixpkgs-unstable {
                inherit system;
                config.allowUnfree = true;
              };
              inherit nullclaw;
            };
          home-manager.users.tyllm = {
            imports = [
              ./home.nix
              catppuccin.homeModules.catppuccin
              noctalia.homeModules.default
              nix-flatpak.homeManagerModules.nix-flatpak
              eilmeldung.homeManager.default

              #./tastes/waybar.nix
              ./tastes/noctalia.nix

              ];
          };
        }
        {
          nixpkgs.overlays = [
            eilmeldung.overlays.default
            agenix.overlays.default
          ];
        }
        nixvim.nixosModules.nixvim
        nix-flatpak.nixosModules.nix-flatpak
        agenix.nixosModules.default
        noctalia-greeter.nixosModules.default
        hermes-agent.nixosModules.default
        
      ];
    };
  };
}
