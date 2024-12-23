{ inputs, ... }:
{
  imports = [
    ./hardware-configuration.nix

    ../common/global
    ../common/users/jamie.nix

    ../common/optional/vscode-server.nix

    ./services
  ];

  networking = {
    hostName = "rpi5";
    #defaultGateway = {
    #  address = "192.168.1.1";
    #  interface = "end0";
    #};
    # interfaces.end0 = {
    #  wakeOnLan.enable = true;
    #  ipv4.addresses = [
    #    {
    #      address = "192.168.1.3";
    #      prefixLength = 24;
    #    }
    #  ];
    #  ipv6.addresses = [
    #    {
    #      address = "fd63:e339:d9fc::3";
    #      prefixLength = 64;
    #    }
    #  ];
    #};
  };

  raspberry-pi-nix.libcamera-overlay.enable = false;

  system.stateVersion = "24.05";
}
