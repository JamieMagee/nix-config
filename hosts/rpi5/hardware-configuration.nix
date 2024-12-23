{ inputs, ... }:
{
  imports = [
    inputs.raspberry-pi-nix.nixosModules.raspberry-pi
  ];

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/44444444-4444-4444-4444-444444444444";
      fsType = "ext4";
    };
    "/boot/firmware" = {
      device = "/dev/disk/by-uuid/2178-694E";
      fsType = "vfat";
      options = [
        "fmask=0022"
        "dmask=0022"
      ];
    };
  };

  raspberry-pi-nix.board = "bcm2712";
  nixpkgs.hostPlatform.system = "aarch64-linux";
}
