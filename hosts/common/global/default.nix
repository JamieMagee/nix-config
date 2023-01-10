{
  lib,
  outputs,
  ...
}: {
  imports =
    [
      ./fish.nix
      ./fwupd.nix
      ./locale.nix
      ./nix.nix
      ./openssh.nix
      ./tailscale.nix
      # ./work.nix
      ./yubikey.nix
    ]
    ++ (builtins.attrValues outputs.nixosModules);

  nixpkgs = {
    overlays = builtins.attrValues outputs.overlays;
    config.allowUnfree = true;
  };

  hardware.enableRedistributableFirmware = true;
  networking.networkmanager.enable = true;

  environment.enableAllTerminfo = true;
}
