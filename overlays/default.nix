{
  additions = final: _prev: import ../pkgs { pkgs = final; };

  uboot-rpi-arm64 = import ./uboot-rpi-arm64.nix;
}
