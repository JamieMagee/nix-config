{pkgs ? import <nixpkgs> {}}: {
  microsoft-identity-broker = pkgs.callPackage ./microsoft-identity-broker {};
}
