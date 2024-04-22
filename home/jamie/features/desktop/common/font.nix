{ pkgs, ... }:
{
  fontProfiles = {
    enable = true;
    monospace = {
      family = "Cascadia Code";
      package = pkgs.nerdfonts.override { fonts = [ "CascadiaCode" ]; };
    };
    regular = {
      family = "Fira Sans";
      package = pkgs.fira;
    };
  };
}
