{
  inputs,
  lib,
  config,
  pkgs,
  outputs,
  ...
}: let
  inherit (inputs.nix-colors) colorSchemes;
  inherit (inputs.nix-colors.lib-contrib {inherit pkgs;}) colorschemeFromPicture nixWallpaperFromScheme;
in {
  imports = with inputs;
    [
      nix-colors.homeManagerModule
      spicetify-nix.homeManagerModule
    ]
    ++ (builtins.attrValues outputs.homeManagerModules);
  nixpkgs = {
    config.allowUnfree = true;
  };

  colorscheme = lib.mkDefault colorSchemes.nord;

  home.file.".colorscheme".text = config.colorscheme.slug;

  programs = {
    home-manager.enable = true;
    git.enable = true;
  };

  systemd.user.startServices = "sd-switch";

  nix = {
    package = pkgs.nix;
    settings = {
      experimental-features = ["nix-command" "flakes" "repl-flake"];
      warn-dirty = false;
    };
  };

  home = {
    username = lib.mkDefault "jamie";
    homeDirectory = lib.mkDefault "/home/${config.home.username}";
    stateVersion = lib.mkDefault "22.05";
  };
}
