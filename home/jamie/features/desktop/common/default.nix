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
    bitwarden-desktop
    libreoffice-stable
    masterpdfeditor4
    signal-desktop
    slack
    vlc
    zoom-us
  ];
}
