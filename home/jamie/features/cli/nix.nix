{ pkgs, ... }:
{
  home.packages = with pkgs; [
    deadnix
    nix-prefetch-github
    nix-update
    nixfmt-rfc-style
    nixpkgs-hammering
    nixpkgs-review
    statix
    treefmt
  ];
}
