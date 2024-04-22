{ lib, pkgs, ... }:
{
  services = {
    xserver = {
      enable = true;
      desktopManager.plasma5 = {
        enable = true;
      };
      displayManager.sddm = {
        enable = true;
      };
    };
  };

  hardware.bluetooth.enable = true;

  environment.systemPackages = with pkgs; [ ark ];
}
