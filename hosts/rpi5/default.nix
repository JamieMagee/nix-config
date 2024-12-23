{ inputs, ... }:
{
  imports = [
    ./hardware-configuration.nix

    ../common/global
    ../common/users/jamie.nix
  ];

  networking = {
    hostName = "rpi5";
  };

  hardware.bluetooth.enable = true;

  raspberry-pi-nix.libcamera-overlay.enable = false;

  system.stateVersion = "24.05";
}
