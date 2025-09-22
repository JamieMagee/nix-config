{ pkgs, lib, ... }:
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
  };
  home.packages = with pkgs; [
    deadnix
    nil
    nix-prefetch-github
    nix-update
    nixfmt-rfc-style
    nixpkgs-hammering
    nixpkgs-review
    statix
    treefmt
  ];
}
