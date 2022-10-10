{pkgs, ...}: {
  boot = {
    initrd = {
      availableKernelModules = ["xhci_pci"];
    };
    loader.timeout = 5;
  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/44444444-4444-4444-8888-888888888888";
    fsType = "ext4";
  };

  fileSystems."/mnt" = {
    device = "/dev/disk/by-uuid/2178-694E";
    fsType = "vfat";
  };

  nixpkgs.hostPlatform.system = "aarch64-linux";
}
