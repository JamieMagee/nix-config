{ pkgs, ... }:
{
  boot = {
    loader = {
      efi = {
        efiSysMountPoint = "/boot/efi";
      };
    };
    initrd = {
      availableKernelModules = [
        "nvme"
        "xhci_pci"
        "ahci"
        "usb_storage"
        "usbhid"
        "sd_mod"
        "thunderbolt"
      ];
      kernelModules = [ "amdgpu" ];
    };
    kernelPackages = pkgs.linuxPackages_latest;
  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/9c03a0e5-cabe-471c-9710-7453f8c7fabe";
    fsType = "ext4";
  };

  fileSystems."/boot/efi" = {
    device = "/dev/disk/by-uuid/D6E8-5551";
    fsType = "vfat";
  };

  swapDevices = [ { device = "/dev/disk/by-uuid/60fcabd5-b1a4-4d80-8f4a-83b41fc5617e"; } ];

  nixpkgs.hostPlatform.system = "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = true;
}
