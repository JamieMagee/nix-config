{
  description = "My NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    hardware.url = "github:nixos/nixos-hardware";

    home-manager = {
      url = "github:nix-community/home-manager";
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
    alejandra,
    ...
  } @ inputs: let
    inherit (nixpkgs.lib) filterAttrs traceVal;
    inherit (builtins) mapAttrs elem;
    inherit (self) outputs;
    notBroken = x: !(x.meta.broken or false);
    supportedSystems = ["x86_64-linux" "aarch64-linux"];
    forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
  in rec {
    templates = import ./templates;
    nixosModules = import ./modules/nixos;
    homeManagerModules = import ./modules/home-manager;
    overlays = import ./overlays;

    legacyPackages = forAllSystems (
      system:
        import nixpkgs {
          inherit system;
          overlays = with overlays; [additions];
          config.allowUnfree = true;
        }
    );

    packages = forAllSystems (
      system:
        import ./pkgs {pkgs = legacyPackages.${system};}
    );
    devShells = forAllSystems (system: {
      default = import ./shell.nix {pkgs = legacyPackages.${system};};
    });

    hydraJobs = rec {
      packages = mapAttrs (sys: filterAttrs (_: pkg: (elem sys pkg.meta.platforms && notBroken pkg))) packages;
      nixos = mapAttrs (_: cfg: cfg.config.system.build.toplevel) nixosConfigurations;
      home = mapAttrs (_: cfg: cfg.activationPackage) homeConfigurations;
    };

    formatter = builtins.mapAttrs (system: pkgs: pkgs.default) alejandra.packages;

    nixosConfigurations = {
      # Desktop
      jamie-desktop = nixpkgs.lib.nixosSystem {
        pkgs = legacyPackages."x86_64-linux";
        specialArgs = {inherit inputs outputs;};
        modules = [./hosts/jamie-desktop];
      };

      # Raspberry Pi 4
      rpi = nixpkgs.lib.nixosSystem {
        pkgs = legacyPackages."aarch64-linux";
        specialArgs = {inherit inputs outputs;};
        modules = [./hosts/rpi];
      };

      # Hyper-V
      jamie-hyperv = nixpkgs.lib.nixosSystem {
        pkgs = legacyPackages."x86_64-linux";
        specialArgs = {inherit inputs outputs;};
        modules = [./hosts/jamie-hyperv];
      };
    };

    homeConfigurations = {
      # Desktop
      "jamie@jamie-desktop" = home-manager.lib.homeManagerConfiguration {
        pkgs = legacyPackages."x86_64-linux";
        extraSpecialArgs = {inherit inputs outputs;};
        modules = [./home/jamie/jamie-desktop.nix];
      };

      # Raspberry Pi 4
      "jamie@rpi" = home-manager.lib.homeManagerConfiguration {
        pkgs = legacyPackages."aarch64-linux";
        extraSpecialArgs = {inherit inputs outputs;};
        modules = [./home/jamie/rpi.nix];
      };

      # Hyper-V
      "jamie@jamie-hyperv" = home-manager.lib.homeManagerConfiguration {
        pkgs = legacyPackages."x86_64-linux";
        extraSpecialArgs = {inherit inputs outputs;};
        modules = [./home/jamie/jamie-hyperv.nix];
      };
    };
  };
}
