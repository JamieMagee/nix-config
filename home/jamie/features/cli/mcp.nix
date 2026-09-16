{
  inputs,
  pkgs,
  lib,
  ...
}:
{
  # The bundled ripgrep's jemalloc does not support 16 KiB page kernels.
  home.sessionVariables.USE_BUILTIN_RIPGREP = "false";

  programs = {
    github-copilot-cli = {
      enable = true;
      enableMcpIntegration = true;
      package = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.copilot-cli;
    };
    mcp = {
      enable = true;
      servers = {
        "azure" = {
          command = "npx";
          args = [
            "-y"
            "@azure/mcp"
            "server"
            "start"
          ];
          enabled = false;
          tools = [ "*" ];
        };
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
            HOMEASSISTANT_URL = "http://10.10.10.2:8123";
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
