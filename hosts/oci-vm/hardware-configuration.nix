{
  pkgs,
  inputs,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  boot = {
    loader.grub = {
      efiSupport = true;
      efiInstallAsRemovable = true;
      device = "nodev";
    };
    initrd = {
      compressor = "zstd";
      compressorArgs = ["-19" "-T0"];
      availableKernelModules = [ "ata_piix" "uhci_hcd" "xen_blkfront" ];
      kernelModules = [ "nvme" ];
    };
    kernelPackages = pkgs.linuxPackages_latest;
  };

  fileSystems = {
    "/boot" = { 
      device = "/dev/disk/by-uuid/D1A8-7749";
      fsType = "vfat";
    };
    "/" = {
      device = "/dev/sda1";
      fsType = "ext4";
    };
  };

  nixpkgs.hostPlatform.system = "aarch64-linux";
}