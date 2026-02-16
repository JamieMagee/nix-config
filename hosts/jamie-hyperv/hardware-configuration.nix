{ pkgs, ... }:
{
  boot.kernelPackages = pkgs.linuxPackages_latest;

  nixpkgs.hostPlatform.system = "x86_64-linux";
}
