{pkgs, config, ...}: {
  imports = [
    ./cloud.nix
    ./esphome.nix
    # ./influxdb.nix
    # ./mqtt.nix
    ./sonos.nix
  ];

  services.home-assistant = {
    enable = true;
    extraComponents = [
      "abode"
      "esphome"
      "econet"
      "met"
      "radio_browser"
      "roomba"
      "yalexs_ble"
      "elgato"
      "plex"
      "unifi"
      "nanoleaf"
      "spotify"
      "aladdin_connect"
      "otp"
      "notify"
      "zha"
      "unifiprotect"
      "adguard"
      "sonarr"
      "radarr"
      "sabnzbd"
      "august"
      "homekit_controller"
      "google_translate"
      "zeroconf"
    ];
    config = {
      default_config = {};
      http = {
        trusted_proxies = [
          "127.0.0.1"
          "::1"
        ];
        use_x_forwarded_for = true;
      };
      homeassistant = {
        auth_mfa_modules = [
          {
            type = "totp";
          }
          {
            type = "notify";
          }
        ];
      };
      "automation manual" = [];
      "automation ui" = "!include automations.yaml";
      "scene manual" = [];
      "scene ui" = "!include scenes.yaml";
    };
  };

  services.caddy.virtualHosts."rpi.tailnet-0b15.ts.net" = {
    extraConfig = ''
      reverse_proxy http://[::1]:8123
    '';
  };

  networking.firewall = {
    allowedTCPPorts = [
      20163
    ];
    allowedUDPPorts = [
      5353
    ];
  };

  systemd.tmpfiles.rules = [
    "f ${config.services.home-assistant.configDir}/automations.yaml 0755 hass hass"
    "f ${config.services.home-assistant.configDir}/scenes.yaml 0755 hass hass"
  ];
}
