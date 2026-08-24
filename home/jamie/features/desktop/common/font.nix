{ pkgs, ... }:
{
  fontProfiles = {
    enable = true;
    monospace = {
      family = "Cascadia Code";
      package = pkgs.nerd-fonts.caskaydia-cove;
    };
    regular = {
      family = "Fira Sans";
      package = pkgs.fira;
    };
  };
}
