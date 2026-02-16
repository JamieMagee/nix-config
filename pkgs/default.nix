{ pkgs }:
let
  specialized-turbo = pkgs.callPackage ./specialized-turbo { };
in
{
  azure-mcp-server = pkgs.callPackage ./azure-mcp-server { };
  inherit specialized-turbo;
  ha-specialized-turbo = pkgs.callPackage ./ha-specialized-turbo { inherit specialized-turbo; };
}
