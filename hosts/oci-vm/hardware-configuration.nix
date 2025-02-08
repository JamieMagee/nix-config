{
  inputs,
  modulesPath,
  ...
}:

{
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")

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
        "xhci_pci"
      ];
    };
  };

  nixpkgs.hostPlatform.system = "aarch64-linux";
}
