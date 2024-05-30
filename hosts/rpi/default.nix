{ inputs, ... }:
{
  imports = [
    inputs.hardware.nixosModules.raspberry-pi-4

    ./hardware-configuration.nix

    ../common/global
    ../common/users/jamie.nix

    ../common/optional/audit.nix
    ../common/optional/earlyoom.nix
    ../common/optional/vscode-server.nix

    ./services
  ];

  networking = {
    hostName = "rpi";
    defaultGateway = {
      address = "192.168.1.1";
      interface = "eth0";
    };
    interfaces.eth0 = {
      wakeOnLan.enable = true;
      ipv4.addresses = [
        {
          address = "192.168.1.2";
          prefixLength = 24;
        }
      ];
      ipv6.addresses = [
        {
          address = "fd63:e339:d9fc::2";
          prefixLength = 64;
        }
      ];
    };
  };

  hardware.bluetooth.enable = true;

  system.stateVersion = "23.11";
}
