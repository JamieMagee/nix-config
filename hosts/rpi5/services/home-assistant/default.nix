{ pkgs, config, ... }:
{
  imports = [
    ./abode.nix
    ./blinds.nix
    ./cloud.nix
    ./default-config.nix
    ./esphome.nix
    ./hvac.nix
    ./leak.nix
    ./lights.nix
    ./lovelace.nix
    ./miele.nix
    ./mqtt.nix
    ./notify.nix
    ./people.nix
    ./recorder.nix
    ./sonos.nix
    ./unifi.nix
    ./vacation.nix
    ./waste-collection.nix
    ./weather.nix
  ];

  services.home-assistant = {
    enable = true;
    package = pkgs.home-assistant.override {
      packageOverrides = self: super: {
        python-roborock = pkgs.python3Packages.python-roborock;
      };
    };
    extraComponents = [
      "adguard"
      "aladdin_connect"
      "androidtv_remote"
      "august"
      "cast"
      "econet"
      "google_translate"
      "homeassistant_hardware"
      "homeassistant_sky_connect"
      "homekit_controller"
      "isal"
      "kegtron" # To avoid "Component not found: kegtron"
      "mcp_server"
      "met"
      "mqtt"
      "notify"
      "opower"
      "otp"
      "plex"
      "radarr"
      "radio_browser"
      "roborock"
      "roomba"
      "sabnzbd"
      "sonarr"
      "spotify"
      "yalexs_ble"
      "zeroconf"
    ];
    customComponents = with pkgs.home-assistant-custom-components; [
      adaptive_lighting
      better_thermostat
      climate_group
      emporia_vue
      fellow
      garmin_connect
      spook
      waste_collection_schedule
    ];
    config = {
      http = {
        trusted_proxies = [
          "127.0.0.1"
          "::1"
        ];
        use_x_forwarded_for = true;
      };
      homeassistant = {
        auth_mfa_modules = [
          { type = "totp"; }
          { type = "notify"; }
        ];
      };
      "automation manual" = [ ];
      "automation ui" = "!include automations.yaml";
      "scene manual" = [ ];
      "scene ui" = "!include scenes.yaml";
    };
  };

  services.caddy.virtualHosts."rpi5.tailnet-0b15.ts.net" = {
    extraConfig = ''
      reverse_proxy http://[::1]:8123
    '';
  };

  networking.firewall = {
    allowedTCPPorts = [ 20163 ];
    allowedUDPPorts = [ 5353 ];
  };

  systemd.tmpfiles.rules = [
    "f ${config.services.home-assistant.configDir}/automations.yaml 0755 hass hass"
    "f ${config.services.home-assistant.configDir}/scenes.yaml 0755 hass hass"
    "f ${config.services.home-assistant.configDir}/secrets.yaml 0755 hass hass"
  ];
}
