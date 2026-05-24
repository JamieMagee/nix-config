{
  additions = final: _prev: import ../pkgs { pkgs = final; };

  uboot-rpi-arm64 = import ./uboot-rpi-arm64.nix;
  github-copilot-cli = import ./github-copilot-cli.nix;
  python-packages = import ./python-packages.nix;
}
