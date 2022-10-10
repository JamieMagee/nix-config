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
    gh
    jq
    p7zip
    ripgrep
    zoxide
  ];
}
