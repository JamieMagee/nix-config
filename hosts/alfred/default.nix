{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.hardware.nixosModules.common-cpu-intel
    inputs.hardware.nixosModules.common-gpu-intel
    inputs.hardware.nixosModules.common-pc-ssd

    ./hardware-configuration.nix

    ../common/global
    ../common/users/jamie.nix

    ../common/optional/systemd-boot.nix
    ../common/optional/vscode-server.nix
  ];

  networking = {
    hostName = "alfred";
    hostId = "a1b2c3d4";
  };

  system.stateVersion = "23.05";
}
