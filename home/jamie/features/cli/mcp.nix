{
  inputs,
  pkgs,
  lib,
  ...
}:
{
  programs = {
    github-copilot-cli = {
      enable = true;
      enableMcpIntegration = true;
      package = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.copilot-cli;
    };
    mcp = {
      enable = true;
      servers = {
        "azure-devops" = {
          command = "npx";
          args = [
            "-y"
            "@azure-devops/mcp"
            "mseng"
          ];
          enabled = false;
          tools = [ "*" ];
        };
        "home-assistant" = {
          command = lib.getExe pkgs.ha-mcp;
          env = {
            HOMEASSISTANT_URL = "http://192.168.1.3:8123";
            HOMEASSISTANT_TOKEN = "$HOMEASSISTANT_TOKEN";
          };
        };
        sentry = {
          url = "https://mcp.sentry.dev/mcp";
          tools = [ "*" ];
        };
      };
    };
  };
}
