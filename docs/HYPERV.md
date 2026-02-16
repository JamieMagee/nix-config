# Hyper-V VM

`jamie-hyperv` is a Generation 2 Hyper-V guest running KDE Plasma with dev tools.

The NixOS config uses the built-in `virtualisation.hypervGuest` module, which loads the `hv_*` kernel modules, installs the Hyper-V daemons, and adds udev rules for CPU/memory hotplug.

## Building the VHDX image

The `hyperv-image` module in nixpkgs produces a VHDX you can import directly into Hyper-V. No manual install needed.

From any machine with Nix installed:

```bash
nix build .#nixosConfigurations.jamie-hyperv.config.system.build.images.hyperv
```

The result is a `.vhdx` file in `./result/`. The default disk size is 4 GiB. The root partition auto-grows on first boot using `boot.growPartition`, so the image stays small even if you allocate a large virtual disk in Hyper-V.

To change the image size at build time, add this to the host config:

```nix
# size in MiB
virtualisation.diskSize = 40 * 1024;
```

## Importing into Hyper-V

1. Copy the `.vhdx` file to your Windows machine
2. Open Hyper-V Manager
3. Create a new VM: **Generation 2**, disable Secure Boot
4. Point the virtual hard disk at the `.vhdx` file you copied
5. Give it at least 2 GB of RAM and 2 vCPUs
6. Start the VM

## After first boot

Once the VM is running, apply config changes from inside it:

```bash
sudo nixos-rebuild switch --flake .#jamie-hyperv
```

Or apply the Home Manager config:

```bash
home-manager switch --flake .#jamie@jamie-hyperv
```

## Disk layout

The image uses GRUB with EFI (installed as removable, since Hyper-V Gen 2 VMs use UEFI). Filesystems are identified by label (`nixos` for root, `ESP` for boot), not by UUID.

## References

- [nixpkgs hyperv-image module](https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/virtualisation/hyperv-image.nix)
- [nixpkgs hyperv-guest module](https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/virtualisation/hyperv-guest.nix)
