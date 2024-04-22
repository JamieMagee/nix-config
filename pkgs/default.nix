{
  pkgs ? import <nixpkgs> { },
}:
{
  par2cmdline-turbo = pkgs.callPackage ./par2cmdline-turbo { };
}
