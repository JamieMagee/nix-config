# System configuration for my main desktop PC
{ inputs, ... }:
{
  imports = [
    inputs.hardware.nixosModules.common-cpu-amd
    inputs.hardware.nixosModules.common-gpu-amd
    inputs.hardware.nixosModules.common-pc-ssd

    ./hardware-configuration.nix

    ../common/global
    ../common/users/jamie.nix

    ../common/optional/dev.nix
    ../common/optional/docker.nix
    ../common/optional/plasma.nix
    ../common/optional/openrgb.nix
    ../common/optional/pipewire.nix
    ../common/optional/steam.nix
    ../common/optional/systemd-boot.nix
    ../common/optional/quietboot.nix
    ../common/optional/virtualisation.nix
    ../common/optional/vpn.nix
  ];

  networking = {
    hostName = "jamie-desktop";
  };

  services.xserver.videoDrivers = [ "amdgpu" ];

  programs = {
    gamemode = {
      enable = true;
      settings.gpu = {
        apply_gpu_optimisations = "accept-responsibility";
        gpu_device = 0;
        amd_performance_level = "high";
      };
    };
  };

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  system.stateVersion = "22.05";
}
