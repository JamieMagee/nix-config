{ pkgs, ... }:
{
  # pkgs.ruby doesn't play well with psych
  # Install ruby with mise instead
  programs = {
    mise = {
      enable = true;
      globalConfig = {
        tools = {
          ruby = "3.3.1";
        };
      };
    };
    fish = {
      shellInit = ''
        fish_add_path ~/.local/share/mise/shims
      '';
    };
  };
}
