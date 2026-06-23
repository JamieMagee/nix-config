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

  # RPi5 kernel doesn't support the nixpkgs default for mmap ASLR entropy
  boot.kernel.sysctl."vm.mmap_rnd_bits" = lib.mkForce null;

  hardware.bluetooth.enable = true;

  raspberry-pi-nix.libcamera-overlay.enable = false;

  # raspberry-pi-nix v0.4.1 pins the kernel to its own old nixpkgs (2024-10),
  # whose kernel derivation lacks the `buildDTBs`/`target` passthru attributes
  # that current nixpkgs NixOS modules (device-tree.nix, top-level.nix) require.
  # Building the kernel against this host's nixpkgs restores those attributes.
  raspberry-pi-nix.pin-inputs.enable = false;

  system.stateVersion = "26.05";
}
