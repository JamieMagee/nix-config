{
  lib,
  pkgs,
  inputs,
  ...
}:
let
  mcp-servers-pkgs = inputs.mcp-servers-nix.packages.${pkgs.system};
in
{
  programs.opencode = {
    enable = true;
    web = {
      enable = true;
    };
    settings = {
      model = "github-copilot/claude-opus-4.5";
      mcp = {
        "github" = {
          type = "local";
          command = [
            (lib.getExe pkgs.github-mcp-server)
            "stdio"
          ];
          enabled = true;
        };
        "nixos" = {
          type = "local";
          command = [
            (lib.getExe pkgs.mcp-nixos)
          ];
          enabled = true;
        };
        "context7" = {
          type = "local";
          command = [
            (lib.getExe mcp-servers-pkgs.context7-mcp)
          ];
          enabled = true;
        };
        "azure" = {
          type = "local";
          command = [
            (lib.getExe pkgs.azure-mcp-server)
            "server"
            "start"
          ];
          enabled = true;
        };
      };
    };
  };
}
