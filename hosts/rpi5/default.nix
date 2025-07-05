{ inputs, nixos-raspberrypi, ... }:
{
  imports = [
    ./hardware-configuration.nix

    ../common/global
    ../common/users/jamie.nix

    ../common/optional/earlyoom.nix
    ../common/optional/vscode-server.nix

    ./services

    nixos-raspberrypi.nixosModules.raspberry-pi-5.base
  ];

  networking = {
    hostName = "rpi5";
    defaultGateway = {
      address = "192.168.1.1";
      interface = "end0";
    };
    interfaces.end0 = {
      wakeOnLan.enable = true;
      ipv4.addresses = [
        {
          address = "192.168.1.3";
          prefixLength = 24;
        }
      ];
    };
  };

  system.stateVersion = "24.05";
}
