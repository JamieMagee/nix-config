{
  pkgs,
  inputs,
  ...
}: {
  boot = {
    initrd = {
      availableKernelModules = ["xhci_pci" "usbhid" "usb_storage"];
    };
    loader = {
      generic-extlinux-compatible.enable = true;
      grub.enable = false;
    };
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
      options = ["noatime"];
    };
  };

  nixpkgs.hostPlatform.system = "aarch64-linux";

  hardware.raspberry-pi."4".poe-hat.enable = true;
}
