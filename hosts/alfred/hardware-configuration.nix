{inputs, modulesPath, pkgs, ...}: {

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
      availableKernelModules = [ "vmd" "ahci" "xhci_pci" "nvme" "usb_storage" "usbhid" "sd_mod" ];
      kernelModules = ["kvm-intel"];
    };
    kernelPackages = pkgs.linuxPackages_latest;
  };

  nixpkgs.hostPlatform.system = "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = true;
}
