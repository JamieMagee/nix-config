{pkgs, ...}: {
  imports = [
    ./fish.nix
    ./git.nix
    ./ssh.nix
    ./starship.nix
    ./yubikey.nix
  ];

  home.packages = with pkgs; [
    alejandra
    bitwarden-cli
    deploy-rs
    fd
    nixpkgs-review
    p7zip
    ripgrep
    skopeo
  ];

  programs = {
    bat = {
      enable = true;
    };
    bottom = {
      enable = true;
    };
    exa = {
      enable = true;
      enableAliases = true;
    };
    fzf = {
      enable = true;
    };
    jq = {
      enable = true;
    };
    zellij = {
      enable = true;
    };
    zoxide = {
      enable = true;
    };
  };
}
