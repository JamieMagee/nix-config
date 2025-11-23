{ inputs, ... }:
{
  imports = [
    inputs.raspberry-pi-nix.nixosModules.raspberry-pi

    # inputs.disko.nixosModules.disko
    # ./disko.nix
  ];

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
              value = 3;
              enable = true;
            };
          };
        };
      };
    };
  };

  raspberry-pi-nix.board = "bcm2712";
  nixpkgs.hostPlatform.system = "aarch64-linux";
}
