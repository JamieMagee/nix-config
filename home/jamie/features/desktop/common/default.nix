{pkgs, ...}: {
  imports = [
    ./dconf.nix
    ./font.nix
    ./firefox.nix
    ./gtk.nix
    ./jetbrains.nix
    ./kitty.nix
    ./spotify.nix
    ./vscode.nix
  ];

  home.packages = with pkgs; [
    bitwarden
    signal-desktop
    slack
    zoom-us
  ];
}
