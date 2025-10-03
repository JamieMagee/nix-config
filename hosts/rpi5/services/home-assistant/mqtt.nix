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
            defaultFan = defaultSwitch // {
              outputMode = "Exhaust Fan (On/Off)";
              smartBulbMode = "Disabled";
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
            "0x001788010de59fb4" = defaultLight // {
              friendly_name = "homelab/zone/garage/light-stairs";
            };
            "0xb43a31fffe380054" = defaultSwitch // {
              friendly_name = "homelab/zone/garage-bathroom/switch-light";
              smartBulbMode = "Disabled";
            };
            "0x048727fffe19208b" = defaultFan // {
              friendly_name = "homelab/zone/garage-bathroom/switch-fan";
              autoTimerOff = 3600;
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
            };
            "0xb43a31fffe38377e" = defaultSwitch // {
              friendly_name = "homelab/zone/living-room/switch-front-porch";
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
            "0xe0798dfffeaa77b1" = defaultSwitch // {
              friendly_name = "homelab/zone/upstairs/switch-hallway-light-2";
              smartBulbMode = "Disabled";
            };
            "0xb43a31fffe3babd1" = defaultSwitch // {
              friendly_name = "homelab/zone/upstairs/switch-stairs-light";
            };
            "0xe0798dfffeaa78c9" = defaultSwitch // {
              friendly_name = "homelab/zone/bedroom/switch-closet";
            };
            "0x001788010de5c71f" = defaultLight // {
              friendly_name = "homelab/zone/bedroom/light-closet";
            };
            "0xe0798dfffeaa77e9" = defaultSwitch // {
              friendly_name = "homelab/zone/upstairs/switch-rooftop";
            };
            "0xe0798dfffeb36d7a" = defaultSwitch // {
              friendly_name = "homelab/zone/bedroom/switch";
            };
            "0xe0798dfffeb3662c" = defaultSwitch // {
              friendly_name = "homelab/zone/office/switch";
            };
            "0x001788010de5c649" = defaultLight // {
              friendly_name = "homelab/zone/office/light";
            };
            "0xb43a31fffe34c1cf" = defaultSwitch // {
              friendly_name = "homelab/zone/upstairs/switch-hallway-light-1";
              smartBulbMode = "Disabled";
            };
            "0x001788010de5c725" = defaultLight // {
              friendly_name = "homelab/zone/upstairs/light-stairs";
            };
            "0x001788010de5c6e8" = defaultLight // {
              friendly_name = "homelab/zone/upstairs/light-hallway-1";
              disabled = true;
            };
            "0x001788010de5c44d" = defaultLight // {
              friendly_name = "homelab/zone/upstairs/light-hallway-2";
              disabled = true;
            };
            "0x001788010de5c72d" = defaultLight // {
              friendly_name = "homelab/zone/bedroom/light-1";
            };
            "0x001788010de5c4a6" = defaultLight // {
              friendly_name = "homelab/zone/bedroom/light-2";
            };
            "0x001788010de5c49a" = defaultLight // {
              friendly_name = "homelab/zone/bedroom/light-3";
            };
            "0x001788010de5cfd3" = {
              friendly_name = "homelab/zone/bedroom/light-4";
            };
            "0x70ac08fffe6c8e2c" = defaultSwitch // {
              friendly_name = "homelab/zone/bathroom/switch-overhead-1";
            };
            "0xe0798dfffeb368c0" = defaultSwitch // {
              friendly_name = "homelab/zone/bathroom/switch-overhead-2";
            };
            "0xe0798dfffeaa7745" = defaultSwitch // {
              friendly_name = "homelab/zone/bathroom/switch-vanity-1";
              smartBulbMode = "Disabled";
            };
            "0x9035eafffec6e806" = defaultSwitch // {
              friendly_name = "homelab/zone/bathroom/switch-vanity-2";
              smartBulbMode = "Disabled";
            };
            "0x001788010de5c4a4" = defaultLight // {
              friendly_name = "homelab/zone/bathroom/light";
            };
            "0x048727fffe1b2e4d" = defaultFan // {
              friendly_name = "homelab/zone/bathroom/fan";
              autoTimerOff = 3600;
            };
            "0x00158d008b7ca529" = {
              friendly_name = "homelab/zone/bathroom/humidity-sensor";
            };
            "0xd44867fffe8bb773" = defaultFan // {
              friendly_name = "homelab/zone/utility-closet/fan";
              autoTimerOff = 3600;
            };

            # Roof
            "0x001788010db42ff9" = defaultLight // {
              friendly_name = "homelab/zone/rooftop/light-1";
            };
            "0x001788010ce32dd5" = defaultLight // {
              friendly_name = "homelab/zone/rooftop/light-2";
            };

            # Outdoors
            "0x001788010dabd66b" = defaultLight // {
              friendly_name = "homelab/zone/outdoors/porch-light";
            };
            "0x001788010daba6e8" = defaultLight // {
              friendly_name = "homelab/zone/outdoors/garage-light-1";
            };
            "0x001788010db42d9c" = defaultLight // {
              friendly_name = "homelab/zone/outdoors/garage-light-";
            };
            "0x001788010db3bab6" = defaultLight // {
              friendly_name = "homelab/zone/outdoors/garage-light-3";
            };
            "0x001788010dabc8e4" = defaultLight // {
              friendly_name = "homelab/zone/outdoors/garage-light-4";
            };
            "0xe0798dfffeb367b4" = defaultSwitch // {
              friendly_name = "homelab/zone/kitchen/switch-balcony";
            };
            "0x001788010daba3ee" = defaultLight // {
              friendly_name = "homelab/zone/outdoors/balcony-light-1";
            };
            "0x001788010ce618a9" = defaultLight // {
              friendly_name = "homelab/zone/outdoors/balcony-light-2";
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

  networking.firewall.allowedTCPPorts = [ 8080 ];
}
