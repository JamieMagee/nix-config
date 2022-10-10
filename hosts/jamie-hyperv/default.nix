{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix

    ../common/global
    ../common/users/jamie.nix

    ../common/optional/gnome.nix
    ../common/optional/pipewire.nix
    ../common/optional/systemd-boot.nix
  ];

  networking = {
    hostName = "jamie-hyperv";
  };

  services.xserver = {
    modules = [pkgs.xorg.xf86videofbdev];
    videoDrivers = ["hyperv_fb"];
  };
  users.users.gdm = {
    extraGroups = ["video"];
  };

  system.stateVersion = "22.05";
}
