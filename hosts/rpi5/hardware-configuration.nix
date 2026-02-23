{ inputs, ... }:
{
  imports = [
    inputs.nixos-raspberrypi.nixosModules.raspberry-pi-5.base
    inputs.nixos-raspberrypi.nixosModules.raspberry-pi-5.page-size-16k
    inputs.nixos-raspberrypi.nixosModules.sd-image

    # inputs.disko.nixosModules.disko
    # ./disko.nix
  ];

  # Override the firmware partition ID to match the actual disk
  sdImage.firmwarePartitionID = "0x2175794e";

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
      options = [
        "data=journal" # Improve reliability
      ];
    };
    "/boot/firmware" = {
      device = "/dev/disk/by-label/FIRMWARE";
      fsType = "vfat";
    };
  };

  hardware = {
    raspberry-pi = {
      config = {
        all = {
          base-dt-params = {
            usb_max_current_enable = {
              enable = true;
              value = 1;
            };
            pciex1_gen = {
              enable = true;
              value = 3;
            };
          };
        };
      };
    };
  };

  boot.kernelParams = [ "rootflags=data=journal" ];
}
