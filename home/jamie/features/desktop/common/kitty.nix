{ config, pkgs, ... }:
let
  kitty-xterm = pkgs.writeShellScriptBin "xterm" ''
    ${config.programs.kitty.package}/bin/kitty -1 "$@"
  '';
in
{
  home = {
    packages = [ kitty-xterm ];
    sessionVariables = {
      TERMINAL = "kitty";
    };
  };

  programs.kitty = {
    enable = true;
    themeFile = "Nord";
    font = {
      name = config.fontProfiles.monospace.family;
      size = 12;
    };
    settings = {
      hide_window_decorations = true;
      window_padding_width = 15;
      scrollback_lines = 100000;
    };
  };
}
