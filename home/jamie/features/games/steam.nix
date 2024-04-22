{ pkgs, ... }:
{
  home.packages = with pkgs; [
    protontricks
    mangohud
  ];
}
