{
  additions = final: _prev: import ../pkgs { pkgs = final; };

  paho-mqtt = import ./paho-mqtt.nix;

  pyjwt = import ./pyjwt.nix;

  uboot-rpi-arm64 = import ./uboot-rpi-arm64.nix;
}
