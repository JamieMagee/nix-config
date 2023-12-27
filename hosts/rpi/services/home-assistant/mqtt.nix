{
  services = {
    zigbee2mqtt = {
      enable = true;
      settings = {
        availability = true;
        homeassistant = true;
        frontend = {
          port = 8080;
        };
        serial = {
          port = "/dev/ttyUSB0";
        };
        advanced = {
          log_level = "debug";
        };

        devices = {
          # Garage
          "0x001788010db5e5e0" = {
            friendly_name = "homelab/zone/garage/light-1";
          };
          "0x001788010d6cef1e" = {
            friendly_name = "homelab/zone/garage/light-2";
          };
          "0x001788010db5e90e" = {
            friendly_name = "homelab/zone/garage/light-3";
          };
          "0x001788010d6cc048" = {
            friendly_name = "homelab/zone/garage/light-4";
          };
          "0x001788010cfc498d" = {
            friendly_name = "homelab/zone/garage/light-5";
          };
          "0x001788010bc2476c" = {
            friendly_name = "homelab/zone/garage/light-6";
          };
          "0x54ef441000899496" = {
            friendly_name = "homelab/zone/garage/motion";
          };

          # Downstairs
          "0x3425b4fffe49ed85" = {
            friendly_name = "homelab/zone/living-room/big-shade";
          };
          "0x187a3efffe469cf2" = {
            friendly_name = "homelab/zone/living-room/small-shade";
          };
          "0x3425b4fffe4f134a" = {
            friendly_name = "homelab/zone/kitchen/shade";
          };

          # Upstairs
          "0x3425b4fffe415425" = {
            friendly_name = "homelab/zone/office/shade";
          };
          "0x3425b4fffe6a4415" = {
            friendly_name = "homelab/zone/bedroom/big-shade";
          };
          "0xe0798dfffebb2faa" = {
            friendly_name = "homelab/zone/bedroom/small-shade";
          };
          "0xe0798dfffec2c88c" = {
            friendly_name = "homelab/zone/bathroom/big-shade";
          };
          "0x3425b4fffecfc7ca" = {
            friendly_name = "homelab/zone/bathroom/small-shade";
          };
          "0xbc026efffe3a9626" = {
            friendly_name = "homelab/zone/upstairs/hallway-shade";
          };
        };
      };
    };
    mosquitto = {
      enable = true;
      listeners = [
        {
          settings = {
            allow_anonymous = true;
          };
          omitPasswordAuth = true;
          acl = ["topic readwrite #"];
          users = {
            zigbee2mqtt = {
              acl = ["readwrite #"];
            };
            home-assistant = {
              acl = ["readwrite #"];
            };
          };
        }
      ];
    };
  };
}
