{ pkgs, ... }:
{
  imports = [
    ./fish.nix
    ./git.nix
    ./micro.nix
    ./ssh.nix
    ./starship.nix
    ./vim.nix
    ./yubikey.nix
  ];

  home = {
    packages = with pkgs; [
      bitwarden-cli
      deploy-rs
      fd
      lazygit
      neofetch
      nixfmt-rfc-style
      nixpkgs-review
      nixpkgs-hammering
      p7zip
      ripgrep
      skopeo
      statix
    ];
    sessionVariables = {
      "ZELLIJ_AUTO_EXIT" = "true";
    };
  };

  programs = {
    atuin = {
      enable = true;
      flags = [ "--disable-up-arrow" ];
    };
    bat = {
      enable = true;
    };
    bottom = {
      enable = true;
    };
    eza = {
      enable = true;
    };
    fzf = {
      enable = true;
    };
    jq = {
      enable = true;
    };
    zellij = {
      enable = true;
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
        default_layout = "compact";
        pane_frames = false;
      };
    };
    zoxide = {
      enable = true;
    };
  };
}
