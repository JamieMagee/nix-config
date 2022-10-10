{lib, ...}: {
  services = {
    xserver = {
      enable = true;
      desktopManager.gnome = {
        enable = true;
      };
      displayManager.gdm = {
        enable = true;
        autoSuspend = false;
      };
    };
    geoclue2.enable = true;
    gnome.gnome-keyring.enable = lib.mkForce false;
  };

  programs.geary.enable = false;
  programs.gnome-terminal.enable = false;
}
