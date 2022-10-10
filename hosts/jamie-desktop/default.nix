# System configuration for my main desktop PC
{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.hardware.nixosModules.common-cpu-amd
    inputs.hardware.nixosModules.common-gpu-amd
    inputs.hardware.nixosModules.common-pc-ssd

    ./hardware-configuration.nix

    ../common/global
    ../common/users/jamie.nix

    ../common/optional/gnome.nix
    ../common/optional/pipewire.nix
    ../common/optional/steam.nix
    ../common/optional/systemd-boot.nix
    ../common/optional/quietboot.nix
  ];

  networking = {
    hostName = "jamie-desktop";
  };

  services.xserver.videoDrivers = ["amdgpu"];

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

  system.stateVersion = "22.05";
}
