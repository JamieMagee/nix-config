{
  lib,
  outputs,
  pkgs,
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
  # https://github.com/NixOS/nixpkgs/issues/180175
  systemd.services.NetworkManager-wait-online.enable = false;

  # https://github.com/NixOS/nixpkgs/issues/258515
  environment.enableAllTerminfo = !pkgs.stdenv.targetPlatform.isAarch64;
}
