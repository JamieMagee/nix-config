{ lib, pkgs, ... }:
{
  programs.opencode = {
    enable = true;
    settings = {
      model = "github-copilot/claude-opus-4.5";
      mcp = {
        "github" = {
          type = "local";
          command = [
            (lib.getExe pkgs.github-mcp-server)
            "stdio"
          ];
          enabled = false;
        };
      };
    };
  };
}
