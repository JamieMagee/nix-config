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
      auto-optimise-store = lib.mkDefault true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      warn-dirty = false;
      substituters = [
        "https://cache.nixos.org"
        "https://nix-community.cachix.org"
      ];
      trusted-substituters = [
        "https://cache.nixos.org"
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };
    package = pkgs.nixVersions.latest;
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
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
