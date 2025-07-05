{ inputs, nixos-raspberrypi, ... }:
{
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
    };
    "/boot/firmware" = {
      device = "/dev/disk/by-label/FIRMWARE";
      fsType = "vfat";
    };
  };

  hardware.raspberry-pi.config = {
    all = {
      base-dt-params = {
        # Enable PCIe
        pciex1 = {
          enable = true;
          value = "on";
        };
        # PCIe Gen 3.0 for better performance
        pciex1_gen = {
          enable = true;
          value = 3;
        };
      };
    };
  };
}
