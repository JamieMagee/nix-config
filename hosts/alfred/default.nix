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
    ../common/optional/quietboot.nix
  ];

  networking = {
    hostName = "alfred";
  };

  system.stateVersion = "23.05";
}
