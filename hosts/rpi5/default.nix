{ lib, ... }:
{
  imports = [
    ./hardware-configuration.nix

    ../common/global
    ../common/users/jamie.nix

    ../common/optional/earlyoom.nix
    ../common/optional/smartd.nix
    ../common/optional/vscode-server.nix

    ./services
  ];

  networking = {
    hostName = "rpi5";
    # defaultGateway = {
    #   address = "192.168.1.1";
    #   interface = "end0";
    # };
    # interfaces.end0 = {
    #   wakeOnLan.enable = true;
    #   ipv4.addresses = [
    #     {
    #       address = "192.168.1.3";
    #       prefixLength = 24;
    #     }
    #   ];
    # };
  };

  # The linux-rpi bcm2712 defconfig caps mmap ASLR entropy at 30 bits.
  boot.kernel.sysctl."vm.mmap_rnd_bits" = lib.mkForce null;

  hardware.bluetooth.enable = true;

  system.stateVersion = "26.05";
}
