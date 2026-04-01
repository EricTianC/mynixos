{
  description = "my simple NixOS flake";

  nixConfig = {
    extra-substituters = [ "https://noctalia.cachix.org" ];
    extra-trusted-public-keys = [ "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4=" ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    # nixpkgs.url = "git+https://mirrors.tuna.tsinghua.edu.cn/git/nixpkgs.git?ref=nixos-25.11&shallow=1";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      # url = "github:nix-community/nixvim/nixos-25.11";
      url = "github:nix-community/nixvim";
      # inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      # inputs.nixpkgs.follows = "nixpkgs";
    };

    mihomosh.url = "path:./mihomosh";

    catppuccin.url = "github:catppuccin/nix/release-25.11";

    # nix-openclaw.url = "github:openclaw/nix-openclaw";
    nullclaw.url = "github:nullclaw/nullclaw";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, nixvim, noctalia, mihomosh, catppuccin, nullclaw, ... }@inputs: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit nixpkgs-unstable; inherit mihomosh; inherit noctalia; inherit nullclaw;};
      modules = [
        ./configuration.nix

        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = { inherit nullclaw; };
          home-manager.users.tyllm = {
            imports = [
              ./home.nix
              catppuccin.homeModules.catppuccin
              noctalia.homeModules.default

              #./tastes/waybar.nix
              ./tastes/noctalia.nix

              ];
          };
        }
        {
          nixpkgs.overlays = [
          ];
        }
        nixvim.nixosModules.nixvim
        
      ];
    };
  };
}
