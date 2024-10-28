{ lib, ... }:
{
  systemd.services.zigbee2mqtt.serviceConfig = {
    Restart = lib.mkForce "always";
    RestartSec = "30";
  };
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
          adapter = "ember";
        };
        advanced = {
          log_level = "warning";
        };

        devices =
          let
            defaultSwitch = {
              ledColorWhenOn = 255;
              ledIntensityWhenOn = 100;
              ledColorWhenOff = 255;
              ledIntensityWhenOff = 0;
              outputMode = "On/Off";
              smartBulbMode = "Smart Bulb Mode";
            };
            defaultLight = {
              color_temp_startup = 65535;
            };
          in
          {
            # Garage
            "0x001788010db5e5e0" = defaultLight // {
              friendly_name = "homelab/zone/garage/light-1";
            };
            "0x001788010d6cef1e" = defaultLight // {
              friendly_name = "homelab/zone/garage/light-2";
            };
            "0x001788010db5e90e" = defaultLight // {
              friendly_name = "homelab/zone/garage/light-3";
            };
            "0x001788010d6cc048" = defaultLight // {
              friendly_name = "homelab/zone/garage/light-4";
            };
            "0x001788010cfc498d" = defaultLight // {
              friendly_name = "homelab/zone/garage/light-5";
            };
            "0x001788010bc2476c" = defaultLight // {
              friendly_name = "homelab/zone/garage/light-6";
            };
            "0x54ef441000899496" = {
              friendly_name = "homelab/zone/garage/motion";
            };
            "0xb43a31fffe34b129" = defaultSwitch // {
              friendly_name = "homelab/zone/garage/switch-outdoors";
            };
            "0xb43a31fffe30b639" = defaultSwitch // {
              friendly_name = "homelab/zone/garage/switch-indoors";
            };
            "0x001788010de59fb4" = {
              friendly_name = "homelab/zone/garage/light-stairs";
            };
            "0xb43a31fffe380054" = defaultSwitch // {
              friendly_name = "homelab/zone/garage-bathroom/switch-light";
              smartBulbMode = "Disabled";
            };
            "0x048727fffe19208b" = defaultSwitch // {
              friendly_name = "homelab/zone/garage-bathroom/switch-fan";
            };
            "0xb43a31fffe38d5b8" = defaultSwitch // {
              friendly_name = "homelab/zone/garage-hallway/switch-stairs";
            };
            "0x00158d000af0cf12" = {
              friendly_name = "homelab/zone/garage-bathroom/sink-leak";
            };
            "0x00158d000af41202" = {
              friendly_name = "homelab/zone/garage-bathroom/toilet-leak";
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
            "0x001788010de59f87" = defaultLight // {
              friendly_name = "homelab/zone/kitchen/light-stairs";
            };
            "0x001788010de588ef" = defaultLight // {
              friendly_name = "homelab/zone/kitchen/light-1";
            };
            "0x001788010de58f56" = defaultLight // {
              friendly_name = "homelab/zone/kitchen/light-2";
            };
            "0x001788010de59fff" = defaultLight // {
              friendly_name = "homelab/zone/kitchen/light-3";
            };
            "0x001788010de59fdc" = defaultLight // {
              friendly_name = "homelab/zone/kitchen/light-4";
            };
            "0xb43a31fffe396ae0" = defaultSwitch // {
              friendly_name = "homelab/zone/kitchen/switch-stairs-light";
            };
            "0xb43a31fffe270352" = defaultSwitch // {
              friendly_name = "homelab/zone/kitchen/switch-kitchen-light";
            };
            "0xb43a31fffe308aa9" = defaultSwitch // {
              friendly_name = "homelab/zone/kitchen/switch-living-room-light";
            };
            "0x001788010de59294" = defaultLight // {
              friendly_name = "homelab/zone/living-room/light-1";
            };
            "0x001788010de58f44" = defaultLight // {
              friendly_name = "homelab/zone/living-room/light-2";
            };
            "0x001788010de58f50" = defaultLight // {
              friendly_name = "homelab/zone/living-room/light-3";
            };
            "0x001788010de59d73" = defaultLight // {
              friendly_name = "homelab/zone/living-room/light-4";
            };
            "0x001788010de59ed5" = defaultLight // {
              friendly_name = "homelab/zone/living-room/light-stairs";
            };
            "0xb43a31fffe307d4a" = defaultSwitch // {
              friendly_name = "homelab/zone/living-room/switch-living-room-light";
            };
            "0xb43a31fffe30b619" = defaultSwitch // {
              friendly_name = "homelab/zone/living-room/switch-kitchen-light";
            };
            "0xb43a31fffe34dcd3" = defaultSwitch // {
              friendly_name = "homelab/zone/living-room/switch-stairs-light";
              smartBulbMode = "Disabled";
            };
            "0xb43a31fffe38377e" = defaultSwitch // {
              friendly_name = "homelab/zone/living-room/switch-front-porch";
              smartBulbMode = "Disabled";
            };
            "0x00158d000af41336" = {
              friendly_name = "homelab/zone/kitchen/sink-leak";
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
            "0x00158d000af0b008" = {
              friendly_name = "homelab/zone/bathroom/toilet-leak";
            };
            "0x00158d000af0b938" = {
              friendly_name = "homelab/zone/bathroom/sink-right-leak";
            };
            "0x00158d000af3faeb" = {
              friendly_name = "homelab/zone/bathroom/sink-left-leak";
            };
          };

        groups = {
          "1" = {
            friendly_name = "homelab/group/kitchen-garage-stairs";
            devices = [
              "0x001788010de59fb4/11"
              "0x001788010de59f87/11"
              "0xb43a31fffe38d5b8/1"
              "0xb43a31fffe396ae0/1"
            ];
          };
          "2" = {
            friendly_name = "homelab/group/living-room-lights";
            devices = [
              "0xb43a31fffe307d4a/1"
              "0xb43a31fffe308aa9/1"
              "0x001788010de59294/11"
              "0x001788010de58f44/11"
              "0x001788010de58f50/11"
              "0x001788010de59d73/11"
            ];
          };
          "3" = {
            friendly_name = "homelab/group/kitchen-lights";
            devices = [
              "0xb43a31fffe30b619/1"
              "0xb43a31fffe270352/1"
              "0x001788010de588ef/11"
              "0x001788010de58f56/11"
              "0x001788010de59fff/11"
              "0x001788010de59fdc/11"
            ];
          };
          "4" = {
            friendly_name = "homelab/group/living-room-stairs";
            devices = [
              "0xb43a31fffe34dcd3/1"
              "0x001788010de59ed5/11"
            ];
          };
          "5" = {
            friendly_name = "homelab/group/front-porch-lights";
            devices = [
              "0xb43a31fffe38377e/1"
            ];
          };
          "6" = {
            friendly_name = "homelab/group/garage-indoor-lights";
            devices = [
              "0xb43a31fffe30b639/1"
              "0x001788010db5e5e0/11"
              "0x001788010d6cef1e/11"
              "0x001788010db5e90e/11"
              "0x001788010d6cc048/11"
              "0x001788010cfc498d/11"
              "0x001788010bc2476c/11"
            ];
          };
          "7" = {
            friendly_name = "homelab/group/garage-outdoor-lights";
            devices = [
              "0xb43a31fffe34b129/1"
            ];
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
          acl = [ "topic readwrite #" ];
          users = {
            zigbee2mqtt = {
              acl = [ "readwrite #" ];
            };
            home-assistant = {
              acl = [ "readwrite #" ];
            };
          };
        }
      ];
    };
  };
}
