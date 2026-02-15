{
  pkgs,
  lib,
  ...
}:
{
  programs.mcp = {
    enable = true;
    servers = {
      "home-assistant" = {
        command = lib.getExe pkgs.ha-mcp;
        env = {
          HOMEASSISTANT_URL = "http://192.168.1.3:8123";
          HOMEASSISTANT_TOKEN = "{env:HOMEASSISTANT_TOKEN}";
        };
      };
    };
  };
}
