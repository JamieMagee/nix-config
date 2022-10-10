{pkgs, ...}: {
  boot = {
    loader = {
      efi = {
        efiSysMountPoint = "/boot/efi";
      };
    };
    initrd = {
      availableKernelModules = ["sd_mod" "sr_mod" "hv_vmbus" "hv_storvsc" "hyperv_fb" "hyperv_keyboard"];
    };
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = ["video=hyperv_fb:1920x1080"];
  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/71b0415f-2a21-43a7-b569-8ca50014b11d";
    fsType = "ext4";
  };

  fileSystems."/boot/efi" = {
    device = "/dev/disk/by-uuid/5634-5425";
    fsType = "vfat";
  };

  nixpkgs.hostPlatform.system = "x86_64-linux";
  virtualisation.hypervGuest.enable = true;
}
