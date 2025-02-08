{ pkgs, inputs, ... }:
{
  imports = [
    ./hardware-configuration.nix

    ../common/global
    ../common/users/jamie.nix

    ../common/optional/systemd-boot.nix
  ];

  networking = {
    hostName = "oci-vm";
  };

  system.stateVersion = "24.11";
}
