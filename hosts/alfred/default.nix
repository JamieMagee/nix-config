{ inputs, ... }:
{
  imports = [
    inputs.hardware.nixosModules.common-cpu-intel
    inputs.hardware.nixosModules.common-pc-ssd

    ./hardware-configuration.nix

    ../common/global
    ../common/users/jamie.nix

    ../common/optional/smartd.nix
    ../common/optional/systemd-boot.nix
    ../common/optional/vscode-server.nix
    ../common/optional/zfs.nix

    ./services
  ];

  networking = {
    hostName = "alfred";
    hostId = "a1b2c3d4";
  };

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  system.stateVersion = "23.05";
}
