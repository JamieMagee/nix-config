{ inputs, lib, ... }:
{
  imports = [
    inputs.hardware.nixosModules.raspberry-pi-5
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

  hardware.raspberry-pi = {
    configtxt.settings.all.dtparam = lib.mkAfter [
      "usb_max_current_enable=1"
      "pciex1_gen=3"
    ];
    firmware = {
      enable = true;
      uboot = {
        enable = true;
      };
    };
  };

  boot = {
    kernelParams = [
      "8250.nr_uarts=1"
      "rootflags=data=journal"
    ];
    # The Pi has no TPM, and linux-rpi omits these generic initrd modules.
    initrd.systemd.tpm2.enable = false;
  };

  nixpkgs.hostPlatform.system = "aarch64-linux";
}
