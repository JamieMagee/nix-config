{pkgs, ...}: {
  imports = [
    ./fish.nix
    ./git.nix
    ./starship.nix
    ./yubikey.nix
  ];

  home.packages = with pkgs; [
    alejandra
    bitwarden-cli
    bottom
    exa
    fd
    jq
    nixpkgs-review
    p7zip
    ripgrep
    skopeo
    zoxide
  ];
}
