{
  description = "My NixOS configuration";

  nixConfig = {
    extra-experimental-features = "nix-command flakes";
    extra-substituters = [
      "https://jamiemagee.cachix.org"
      "https://cache.numtide.com"
    ];
    extra-trusted-public-keys = [
      "jamiemagee.cachix.org-1:IzalYx3F8h0uP7EdifGZxqGkTwaQIKXj0i67PuNNYM8="
      "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
    ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    hardware = {
      url = "github:NixOS/nixos-hardware";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.utils.inputs.systems.follows = "systems";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence = {
      url = "github:nix-community/impermanence";
      inputs.home-manager.follows = "home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    vscode-server = {
      url = "github:nix-community/nixos-vscode-server";
      inputs.flake-parts.inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    mcp-servers-nix = {
      url = "github:natsukium/mcp-servers-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Intentionally not following nixpkgs so we get binary cache hits from
    # https://cache.numtide.com (see nixConfig above).
    llm-agents = {
      url = "github:numtide/llm-agents.nix";
      inputs.systems.follows = "systems";
    };

    systems.url = "github:nix-systems/default";

    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/*";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      deploy-rs,
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
            inherit inputs outputs;
          };
          modules = modules ++ [
            inputs.determinate.nixosModules.default
            ./hosts/${hostname}
          ];
        };

      mkHome =
        username: hostname: system: extraModules:
        home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${system};
          extraSpecialArgs = {
            inherit inputs outputs;
          };
          modules = [
            ./home/${username}/${hostname}.nix
          ]
          ++ extraModules;
        };
    in
    {
      nixosModules = import ./modules/nixos;
      homeManagerModules = import ./modules/home-manager;
      overlays = import ./overlays;

      packages = forAllSystems (system: import ./pkgs { pkgs = nixpkgs.legacyPackages.${system}; });
      devShells = forAllSystems (system: {
        default = nixpkgs.legacyPackages.${system}.callPackage ./shell.nix { };
      });

      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt);

      nixosConfigurations = {
        alfred = mkSystem "alfred" "x86_64-linux" [ ];
        jamie-desktop = mkSystem "jamie-desktop" "x86_64-linux" [ ];
        jamie-hyperv = mkSystem "jamie-hyperv" "x86_64-linux" [ ];
        oci-vm = mkSystem "oci-vm" "aarch64-linux" [ ];
        rpi5 = mkSystem "rpi5" "aarch64-linux" [ ];
        rpi5-image = mkSystem "rpi5" "aarch64-linux" [
          (
            { modulesPath, ... }:
            {
              imports = [ "${modulesPath}/installer/sd-card/sd-image-aarch64.nix" ];
              sdImage.firmwarePartitionID = "0x2175794e";
            }
          )
        ];
      };

      homeConfigurations = {
        "jamie@alfred" = mkHome "jamie" "alfred" "x86_64-linux" [ ];
        "jamie@generic" = mkHome "jamie" "generic" "x86_64-linux" [ ];
        "jamie@jamagee-desktop" = mkHome "jamie" "wsl" "x86_64-linux" [ ];
        "jamie@jamagee-surface2" = mkHome "jamie" "wsl" "x86_64-linux" [ ];
        "jamie@jamie-desktop" = mkHome "jamie" "wsl" "x86_64-linux" [ ];
        "jamie@jamie-hyperv" = mkHome "jamie" "jamie-hyperv" "x86_64-linux" [ ];
        "jamie@oci-vm" = mkHome "jamie" "oci-vm" "aarch64-linux" [ ];
        "jamie@rpi5" = mkHome "jamie" "rpi5" "aarch64-linux" [ ];
      };

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

      checks = forAllSystems (system: deploy-rs.lib.${system}.deployChecks self.deploy);
    };
}
