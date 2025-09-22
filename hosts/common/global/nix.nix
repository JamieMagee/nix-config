{
  pkgs,
  inputs,
  lib,
  config,
  ...
}:
{
  nix = {
    settings = {
      trusted-users = [
        "root"
        "@wheel"
      ];
      accept-flake-config = true;
      auto-optimise-store = lib.mkDefault true;
      download-buffer-size = 2 * 1024 * 1024 * 1024; # 2 GiB
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      http-connections = 512;
      warn-dirty = false;
      substituters = [
        "https://cache.nixos.org"
        "https://nix-community.cachix.org"
        "https://jamiemagee.cachix.org"
      ];
      trusted-substituters = [
        "https://cache.nixos.org"
        "https://nix-community.cachix.org"
        "https://jamiemagee.cachix.org"
      ];
      trusted-public-keys = [
        "nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "jamiemagee.cachix.org-1:IzalYx3F8h0uP7EdifGZxqGkTwaQIKXj0i67PuNNYM8="
      ];
    };
    package = pkgs.nixVersions.latest;
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };

    # Add each flake input as a registry
    # To make nix3 commands consistent with the flake
    registry = lib.mapAttrs (_: value: { flake = value; }) inputs;

    # Map registries to channels
    # Very useful when using legacy commands
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;
  };

  system.activationScripts.system-report-changes = ''
    PATH=$PATH:${
      lib.makeBinPath [
        pkgs.nvd
        pkgs.nix
      ]
    }
    # Disable nvd if there are lesser than 2 profiles in the system.
    if [ $(ls -d1v /nix/var/nix/profiles/system-*-link 2>/dev/null | wc -l) -lt 2 ];
    then
        echo "Skipping reporting changes..."
    else
        nvd diff $(ls -d1v /nix/var/nix/profiles/system-*-link | tail -2)
    fi
  '';
}
