{
  description = "My NixOS configuration";

  nixConfig = {
    extra-experimental-features = "nix-command flakes";
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    hardware.url = "github:NixOS/nixos-hardware";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-raspberrypi.url = "github:nvmd/nixos-raspberrypi";

    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-colors.url = "github:misterio77/nix-colors";

    vscode-server = {
      url = "github:nix-community/nixos-vscode-server";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      deploy-rs,
      nixos-raspberrypi,
      ...
    }@inputs:
    let
      inherit (self) outputs;
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;

      # Helper functions
      mkSystem =
        hostname: system: modules:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit inputs outputs nixos-raspberrypi;
          };
          modules = modules ++ [ ./hosts/${hostname} ];
        };

      mkHome =
        username: hostname: system: extraModules:
        home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${system};
          extraSpecialArgs = {
            inherit inputs outputs;
          };
          modules = [ ./home/${username}/${hostname}.nix ] ++ extraModules;
        };

      # Common configurations
      wslConfig = [ ./home/jamie/wsl.nix ];
    in
    {
      # Standard flake outputs
      nixosModules = import ./modules/nixos;
      homeManagerModules = import ./modules/home-manager;
      overlays = import ./overlays;

      packages = forAllSystems (system: import ./pkgs { pkgs = nixpkgs.legacyPackages.${system}; });
      devShells = forAllSystems (system: {
        default = nixpkgs.legacyPackages.${system}.callPackage ./shell.nix { };
      });

      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt-rfc-style);

      nixosConfigurations = {
        alfred = mkSystem "alfred" "x86_64-linux" [ ];
        jamie-desktop = mkSystem "jamie-desktop" "x86_64-linux" [ ];
        oci-vm = mkSystem "oci-vm" "aarch64-linux" [ ];
        rpi5 = nixos-raspberrypi.lib.nixosSystem {
          specialArgs = {
            inherit inputs outputs nixos-raspberrypi;
          };
          modules = [
            ./hosts/rpi5/default.nix
          ];
        };
      };

      homeConfigurations = {
        "jamie@alfred" = mkHome "jamie" "alfred" "x86_64-linux" [ ];
        "jamie@generic" = mkHome "jamie" "generic" "x86_64-linux" [ ];
        "jamie@jamagee-desktop" = mkHome "jamie" "wsl" "x86_64-linux" [ ];
        "jamie@jamagee-surface2" = mkHome "jamie" "wsl" "x86_64-linux" [ ];
        "jamie@jamie-desktop" = mkHome "jamie" "wsl" "x86_64-linux" [ ];
        "jamie@oci-vm" = mkHome "jamie" "oci-vm" "aarch64-linux" [ ];
        "jamie@rpi5" = mkHome "jamie" "rpi5" "aarch64-linux" [ ];
      };

      # deploy-rs configuration (custom output for deploy-rs)
      deploy = {
        fastConnection = true;
        magicRollback = false;
        sshOpts = [ "-t" ];
        nodes = {
          rpi5 = {
            hostname = "rpi5.tailnet-0b15.ts.net";
            sshOpts = [
              "-p"
              "2222"
            ];
            profiles = {
              system = {
                user = "root";
                path = deploy-rs.lib.aarch64-linux.activate.nixos self.nixosConfigurations.rpi5;
              };
              home = {
                user = "jamie";
                path = deploy-rs.lib.aarch64-linux.activate.home-manager self.homeConfigurations."jamie@rpi5";
              };
            };
          };
        };
      };

      # Add deploy-rs checks only for aarch64-linux system
      checks = {
        aarch64-linux = deploy-rs.lib.aarch64-linux.deployChecks self.deploy;
      };
    };
}
