{pkgs, ...}: {
  imports = [
    ./fish.nix
    ./git.nix
    ./micro.nix
    ./ssh.nix
    ./starship.nix
    ./yubikey.nix
  ];

  home.packages = with pkgs; [
    alejandra
    bitwarden-cli
    deploy-rs
    fd
    neofetch
    nixpkgs-review
    nixpkgs-hammering
    p7zip
    ripgrep
    skopeo
    statix
  ];

  programs = {
    bat = {
      enable = true;
    };
    bottom = {
      enable = true;
    };
    eza = {
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
      enableBashIntegration = true;
      enableFishIntegration = true;
      settings = {
        theme = "nord";
        themes.nord = {
          fg = "#D8DEE9";
          bg = "#2E3440";
          black = "#3B4252";
          red = "#BF616A";
          green = "#A3BE8C";
          yellow = "#EBCB8B";
          blue = "#81A1C1";
          magenta = "#B48EAD";
          cyan = "#88C0D0";
          white = "#E5E9F0";
          orange = "#D08770";
        };
      };
    };
    zoxide = {
      enable = true;
    };
  };
}
