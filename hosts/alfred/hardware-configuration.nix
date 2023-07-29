{inputs, modulesPath, pkgs, ...}: {

  imports = [
    "${modulesPath}/profiles/qemu-guest.nix"
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
      availableKernelModules = [ "ahci" "xhci_pci" "virtio_pci" "sr_mod" "virtio_blk" ];
      kernelModules = ["kvm-intel"];
    };
    kernelPackages = pkgs.linuxPackages_latest;
  };

  nixpkgs.hostPlatform.system = "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = true;
}
