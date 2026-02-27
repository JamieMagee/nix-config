# System configuration for Hyper-V VM
{ ... }:
{
  imports = [
    ./hardware-configuration.nix

    ../common/global
    ../common/users/jamie.nix

    ../common/optional/dev.nix
    ../common/optional/docker.nix
    ../common/optional/pipewire.nix
    ../common/optional/plasma.nix
    ../common/optional/vscode-server.nix
  ];

  networking = {
    hostName = "jamie-hyperv";
  };

  virtualisation.hypervGuest.enable = true;

  # Match the hyperv-image module's bootloader and filesystem layout
  # so `nixos-rebuild build-image --image-variant hyperv` works cleanly
  boot = {
    growPartition = true;
    loader.grub = {
      device = "nodev";
      efiSupport = true;
      efiInstallAsRemovable = true;
    };
  };

  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    autoResize = true;
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/ESP";
    fsType = "vfat";
  };

  system.stateVersion = "26.05";
}
