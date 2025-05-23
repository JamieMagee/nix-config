{ pkgs, ... }:
{
  imports = [
    ./dconf.nix
    ./font.nix
    ./firefox.nix
    ./gtk.nix
    ./jetbrains.nix
    ./kitty.nix
    ./vscode.nix
  ];

  home.packages = with pkgs; [
    bitwarden
    libreoffice-fresh
    masterpdfeditor4
    signal-desktop
    slack
    vlc
    zoom-us
  ];
}
