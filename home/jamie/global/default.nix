{
  inputs,
  lib,
  config,
  pkgs,
  outputs,
  ...
}:
let
  inherit (inputs.nix-colors) colorSchemes;
  inherit (inputs.nix-colors.lib-contrib { inherit pkgs; })
    colorschemeFromPicture
    nixWallpaperFromScheme
    ;
in
{
  imports =
    with inputs;
    [
      nix-colors.homeManagerModule
      spicetify-nix.homeManagerModule
      nixvim.homeManagerModules.nixvim
    ]
    ++ (builtins.attrValues outputs.homeManagerModules);
  nixpkgs = {
    overlays = builtins.attrValues outputs.overlays;
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
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
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      warn-dirty = false;
    };
  };

  home = {
    username = lib.mkDefault "jamie";
    homeDirectory = lib.mkDefault "/home/${config.home.username}";
    stateVersion = lib.mkDefault "22.05";
  };
}
