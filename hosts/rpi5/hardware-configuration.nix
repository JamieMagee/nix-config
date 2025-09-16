{ inputs, ... }:
{
  imports = [
    inputs.nixos-raspberrypi.nixosModules.raspberry-pi-5.base
    inputs.nixos-raspberrypi.nixosModules.raspberry-pi-5.bluetooth
    inputs.disko.nixosModules.disko
    ./disko.nix
  ];

  # PCIe configuration for better NVMe performance
  hardware.raspberry-pi.config.all.base-dt-params = {
    pciex1_gen = {
      value = 3;
      enable = true;
    };
  };
}
