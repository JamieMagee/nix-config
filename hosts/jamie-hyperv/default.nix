{ pkgs, inputs, ... }:
{
  imports = [
    ./hardware-configuration.nix

    ../common/global
    ../common/users/jamie.nix

    ../common/optional/plasma.nix
    ../common/optional/pipewire.nix
    ../common/optional/systemd-boot.nix
  ];

  networking = {
    hostName = "jamie-hyperv";
  };

  services.xserver = {
    modules = [ pkgs.xorg.xf86videofbdev ];
    videoDrivers = [ "hyperv_fb" ];
  };

  system.stateVersion = "22.05";
}
