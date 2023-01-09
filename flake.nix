{
  description = "My NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    hardware.url = "github:nixos/nixos-hardware";
    sops-nix.url = "github:mic92/sops-nix";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    alejandra = {
      url = "github:kamadorueda/alejandra/3.0.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-colors.url = "github:misterio77/nix-colors";
    spicetify-nix.url = "github:the-argus/spicetify-nix";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    deploy-rs,
    alejandra,
    ...
  } @ inputs: let
    inherit (builtins) mapAttrs;
    inherit (self) outputs;
    supportedSystems = ["x86_64-linux" "aarch64-linux"];
    forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
  in rec {
    nixosModules = import ./modules/nixos;
    homeManagerModules = import ./modules/home-manager;
    overlays = import ./overlays;

    packages = forAllSystems (
      system:
        import ./pkgs {pkgs = nixpkgs.legacyPackages.${system};}
    );
    devShells = forAllSystems (system: {
      default = nixpkgs.legacyPackages.${system}.callPackage ./shell.nix {};
    });

    formatter = builtins.mapAttrs (system: pkgs: pkgs.default) alejandra.packages;

    nixosConfigurations = {
      # Desktop
      jamie-desktop = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [./hosts/jamie-desktop];
      };

      # Raspberry Pi 4
      rpi = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [./hosts/rpi];
      };

      # Hyper-V
      jamie-hyperv = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [./hosts/jamie-hyperv];
      };
    };

    homeConfigurations = {
      # Desktop
      "jamie@jamie-desktop" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages."x86_64-linux";
        extraSpecialArgs = {inherit inputs outputs;};
        modules = [./home/jamie/jamie-desktop.nix];
      };

      # Raspberry Pi 4
      "jamie@rpi" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages."aarch64-linux";
        extraSpecialArgs = {inherit inputs outputs;};
        modules = [./home/jamie/rpi.nix];
      };

      # Hyper-V
      "jamie@jamie-hyperv" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages."x86_64-linux";
        extraSpecialArgs = {inherit inputs outputs;};
        modules = [./home/jamie/jamie-hyperv.nix];
      };

      # Portable minimum configuration
      "jamie@generic" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages."x86_64-linux";
        extraSpecialArgs = {inherit inputs outputs;};
        modules = [./home/jamie/generic.nix];
      };
    };

    deploy = {
      fastConnection = true;
      magicRollback = false;
      sshOpts = ["-t"];
      nodes = {
        rpi = {
          hostname = "rpi.tailnet-0b15.ts.net";
          sshOpts = ["-p" "2222"];

          profiles = {
            system = {
              user = "root";
              path = deploy-rs.lib.aarch64-linux.activate.nixos self.nixosConfigurations.rpi;
            };
            home = {
              user = "jamie";
              path = deploy-rs.lib.aarch64-linux.activate.home-manager self.homeConfigurations."jamie@rpi";
            };
          };
        };
      };
    };

    deployChecks = {};
  };
}
