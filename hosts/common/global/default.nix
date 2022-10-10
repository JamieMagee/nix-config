{
  lib,
  outputs,
  ...
}: {
  imports =
    [
      # ./binfmt.nix
      ./fish.nix
      ./fwupd.nix
      ./locale.nix
      ./nix.nix
      ./openssh.nix
      ./tailscale.nix
      # ./work.nix
    ]
    ++ (builtins.attrValues outputs.nixosModules);

  nixpkgs = {
    config.allowUnfree = true;
  };

  hardware.enableRedistributableFirmware = true;
  networking.networkmanager.enable = true;
}
