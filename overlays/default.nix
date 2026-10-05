{
  additions = final: _prev: import ../pkgs { pkgs = final; };

  pyjwt = import ./pyjwt.nix;

  uboot-rpi-arm64 = import ./uboot-rpi-arm64.nix;
}
