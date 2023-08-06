{pkgs, ...}: {
  imports = [
    ./cloud.nix
    ./esphome.nix
    ./influxdb.nix
    ./mqtt.nix
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
    };
  };

  services.caddy.virtualHosts."rpi.tailnet-0b15.ts.net" = {
    extraConfig = ''
      reverse_proxy http://[::1]:8123
    '';
  };
}
