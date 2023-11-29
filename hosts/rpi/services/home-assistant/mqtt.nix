{
  services.zigbee2mqtt = {
    enable = true;
    settings = {
      homeassistant = true;
      frontend = {
        port = 8080;
      };
      serial = {
        port = "/dev/ttyUSB0";
      };
    };
  };

  services.mosquitto = {
    enable = true;
    listeners = [
      {
        settings = {
          allow_anonymous = true;
        };
        acl = [ "topic readwrite #"];
        users = {
          zigbee2mqtt = {
            acl = [ "readwrite #" ];
          };
        };
      }
    ];
  };

  services.caddy.virtualHosts."rpi.tailnet-0b15.ts.net" = {
    extraConfig = ''
      handle_path /zigbee2mqtt* {
        reverse_proxy http://127.0.0.1:8080
      }

      @zigbee2mqtt {
        header Referer https://rpi.tailnet-0b15.ts.net/zigbee2mqtt
      }
      reverse_proxy @zigbee2mqtt http://127.0.0.1:8080
    '';
  };
}
