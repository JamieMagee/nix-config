{ pkgs, ... }:
{
  imports = [
    ./fish.nix
    ./git.nix
    ./jujutsu.nix
    ./micro.nix
    ./nix.nix
    ./ssh.nix
    ./starship.nix
    ./yubikey.nix
  ];

  home = {
    packages = with pkgs; [
      bicep
      # bitwarden-cli
      deploy-rs
      devenv
      fastfetchMinimal
      fd
      llm-agents.copilot-cli
      glow
      lazygit
      p7zip
      ripgrep
      skopeo
      statix
      trippy
      yq-go
    ];
  };

  programs = {
    atuin = {
      enable = true;
      flags = [ "--disable-up-arrow" ];
      daemon = {
        enable = true;
      };
      settings = {
        daemon = {
          enabled = true;
        };
      };
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
    npm.settings = {
      # Disable all scripts, including lifecycle scripts and package scripts.
      ignore-scripts = true;
      # Don't install any packages newer than 3 days old.
      min-release-age = 3;
      # Always save exact versions, never use semver ranges.
      save-exact = true;
      # Only allow these operations to be performed on the root project, not by transitive dependencies.
      allow-directory = "root";
      allow-file = "root";
      allow-git = "root";
      allow-remote = "root";
      # Noise
      fund = false;
      update-notifier = false;

    };
    zellij = {
      enable = true;
      settings = {
        theme = "dracula";
        themes = {
          nord = {
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
        default_layout = "compact";
        pane_frames = false;
        show_startup_tips = false;
      };
    };
    zoxide = {
      enable = true;
    };
  };
}
