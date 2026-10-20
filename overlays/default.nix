{
  additions = final: _prev: import ../pkgs { pkgs = final; };

  elgato = import ./elgato.nix;

  pyjwt = import ./pyjwt.nix;

  uboot-rpi-arm64 = import ./uboot-rpi-arm64.nix;
}
