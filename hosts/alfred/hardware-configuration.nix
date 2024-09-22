{
  inputs,
  modulesPath,
  pkgs,
  config,
  ...
}:
{
  imports = [
    inputs.disko.nixosModules.disko
    ./disko.nix
  ];

  boot = {
    loader = {
      efi = {
        efiSysMountPoint = "/boot";
      };
    };
    initrd = {
      availableKernelModules = [
        "vmd"
        "ahci"
        "xhci_pci"
        "nvme"
        "usb_storage"
        "usbhid"
        "sd_mod"
      ];
      kernelModules = [ "kvm-intel" ];
    };
    extraModprobeConfig = ''
      options zfs zfs_arc_max=${toString (72 * 1024 * 1024 * 1024)}
    '';
  };

  powerManagement.cpuFreqGovernor = "powersave";

  nixpkgs.hostPlatform.system = "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = true;
}
