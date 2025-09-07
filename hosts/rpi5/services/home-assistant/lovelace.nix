{ pkgs, ... }:
{
  services.home-assistant = {
    customLovelaceModules = with pkgs.home-assistant-custom-lovelace-modules; [
      bubble-card
      mushroom
      mini-graph-card
      card-mod
      button-card
    ];
    lovelaceConfig = {
      title = "Home";
      views = [
        {
          title = "Home";
          cards = [
            {
              show_current = true;
              show_forecast = true;
              type = "weather-forecast";
              entity = "weather.forecast_home";
              forecast_type = "daily";
            }
            {
              type = "horizontal-stack";
              cards = [
                {
                  type = "tile";
                  entity = "person.jamie";
                }
                {
                  type = "tile";
                  entity = "person.kat";
                }
              ];
            }
            {
              type = "tile";
              entity = "alarm_control_panel.abode_alarm";
              features = [
                {
                  type = "alarm-modes";
                  modes = [
                    "armed_home"
                    "armed_away"
                    "disarmed"
                  ];
                }
              ];
            }
            {
              type = "tile";
              entity = "cover.garage_door";
              features = [ { type = "cover-open-close"; } ];
            }
            {
              type = "horizontal-stack";
              cards = [
                {
                  show_name = true;
                  show_icon = true;
                  type = "button";
                  tap_action = {
                    action = "navigate";
                    navigation_path = "/lovelace/garage";
                  };
                  name = "Garage";
                  icon = "mdi:garage";
                  icon_height = "64px";
                  hold_action = {
                    action = "none";
                  };
                }
                {
                  show_name = true;
                  show_icon = true;
                  type = "button";
                  tap_action = {
                    action = "navigate";
                    navigation_path = "/lovelace/downstairs";
                  };
                  name = "Downstairs";
                  icon = "mdi:alpha-d-box";
                  show_state = false;
                  icon_height = "64px";
                  hold_action = {
                    action = "none";
                  };
                }
                {
                  show_name = true;
                  show_icon = true;
                  type = "button";
                  tap_action = {
                    action = "navigate";
                    navigation_path = "/lovelace/upstairs";
                  };
                  name = "Upstairs";
                  icon_height = "64px";
                  hold_action = {
                    action = "none";
                  };
                  icon = "mdi:alpha-u-box";
                }
              ];
            }
            {
              type = "horizontal-stack";
              cards = [
                {
                  show_name = true;
                  show_icon = true;
                  type = "button";
                  entity = "binary_sensor.doors";
                  icon = "mdi:door";
                  show_state = false;
                  icon_height = "64px";
                }
                {
                  show_name = true;
                  show_icon = true;
                  type = "button";
                  entity = "binary_sensor.windows";
                  icon = "mdi:window-closed";
                  icon_height = "64px";
                }
              ];
            }
            {
              type = "entities";
              entities = [ "sensor.seattle_garbage_collection" ];
            }
            {
              type = "grid";
              square = false;
              columns = 1;
              cards = [
                {
                  type = "picture-entity";
                  entity = "camera.g4_doorbell_pro_high";
                }
                {
                  type = "picture-entity";
                  entity = "camera.g4_doorbell_pro_package_camera";
                }
              ];
            }
            {
              type = "entities";
              entities = [ "input_boolean.vacation_mode" ];
            }
          ];
        }
        {
          title = "Garage";
          path = "garage";
          subview = false;
          icon = "mdi:garage";
          badges = [ ];
          cards = [
            {
              type = "entities";
              entities = [
                { entity = "light.homelab_group_garage_indoors_lights"; }
                { entity = "light.homelab_zone_garage_bathroom_switch_light"; }
                { entity = "light.jamie_ring_light"; }
                { entity = "light.shapes_acf4"; }
              ];
            }
            {
              type = "tile";
              entity = "cover.garage_door";
              features = [ { type = "cover-open-close"; } ];
            }
            {
              type = "tile";
              entity = "water_heater.heat_pump_water_heater";
            }
            {
              type = "tile";
              entity = "binary_sensor.garage_door";
            }
            {
              type = "thermostat";
              entity = "climate.mysa_2bbd00_thermostat";
              name = "Garage";
              show_current_as_primary = false;
            }
            {
              type = "thermostat";
              entity = "climate.mysa_89501c_thermostat";
              name = "Downstairs";
            }
          ];
        }
        {
          subview = false;
          title = "Downstairs";
          path = "downstairs";
          icon = "mdi:alpha-d-box";
          badges = [ ];
          cards = [
            {
              type = "tile";
              entity = "lock.front_door";
              show_entity_picture = false;
              vertical = false;
            }
            {
              type = "tile";
              entity = "climate.esphome_web_6c37b0_downstairs_mini_split";
            }
            {
              type = "horizontal-stack";
              title = "Blinds";
              cards = [
                {
                  show_name = true;
                  show_icon = true;
                  type = "button";
                  entity = "scene.downstairs_blinds_daytime";
                  hold_action = {
                    action = "none";
                  };
                  tap_action = {
                    action = "toggle";
                  };
                  name = "Daytime";
                }
                {
                  show_name = true;
                  show_icon = true;
                  type = "button";
                  hold_action = {
                    action = "none";
                  };
                  name = "Close";
                  tap_action = {
                    action = "call-service";
                    service = "cover.close_cover";
                    target = {
                      entity_id = "cover.downstairs_blinds";
                    };
                  };
                  icon = "mdi:roller-shade-closed";
                }
                {
                  show_name = true;
                  show_icon = true;
                  type = "button";
                  tap_action = {
                    action = "navigate";
                    navigation_path = "/lovelace/downstairs-blinds";
                  };
                  name = "Individual";
                  icon = "mdi:format-list-numbered";
                }
              ];
            }
            {
              type = "horizontal-stack";
              cards = [
                {
                  type = "tile";
                  entity = "binary_sensor.front_door";
                }
                {
                  type = "tile";
                  entity = "binary_sensor.balcony_door";
                }
              ];
            }
            {
              type = "horizontal-stack";
              cards = [
                {
                  type = "tile";
                  entity = "binary_sensor.front_window";
                }
              ];
            }
            {
              type = "entities";
              entities = [
                { entity = "light.homelab_group_kitchen_garage_stairs"; }
                { entity = "light.homelab_group_kitchen_lights"; }
                { entity = "light.homelab_group_living_room_lights"; }
                { entity = "light.homelab_group_living_room_stairs"; }
              ];
            }
          ];
        }
        {
          title = "Downstairs blinds";
          path = "downstairs-blinds";
          icon = "mdi:blinds";
          subview = true;
          badges = [ ];
          cards = [
            {
              type = "vertical-stack";
              cards = [
                {
                  features = [ { type = "cover-open-close"; } ];
                  type = "tile";
                  entity = "cover.homelab_zone_living_room_big_shade";
                  name = "Front window";
                }
                {
                  features = [ { type = "cover-open-close"; } ];
                  type = "tile";
                  entity = "cover.homelab_zone_living_room_small_shade";
                  name = "Side window";
                }
                {
                  features = [ { type = "cover-open-close"; } ];
                  type = "tile";
                  entity = "cover.homelab_zone_kitchen_shade";
                  name = "Kitchen window";
                }
              ];
            }
          ];
        }
        {
          title = "Upstairs";
          path = "upstairs";
          icon = "mdi:alpha-u-box";
          subview = false;
          badges = [ ];
          cards = [
            {
              type = "tile";
              entity = "light.kat_ring_light";
              features = [ { type = "light-brightness"; } ];
            }
            {
              type = "horizontal-stack";
              cards = [
                {
                  show_name = true;
                  show_icon = true;
                  type = "button";
                  tap_action = {
                    action = "toggle";
                  };
                  entity = "scene.upstairs_blinds_daytime";
                  name = "Daytime ";
                }
                {
                  show_name = true;
                  show_icon = true;
                  type = "button";
                  tap_action = {
                    action = "call-service";
                    service = "cover.close_cover";
                    target = {
                      entity_id = "cover.upstairs_blinds";
                    };
                  };
                  name = "Close";
                  icon = "mdi:roller-shade-closed";
                }
                {
                  show_name = true;
                  show_icon = true;
                  type = "button";
                  tap_action = {
                    action = "navigate";
                    navigation_path = "/lovelace/upstairs-blinds";
                  };
                  name = "Individual ";
                  icon = "mdi:format-list-numbered";
                }
              ];
            }
            {
              type = "vertical-stack";
              cards = [
                {
                  type = "tile";
                  entity = "climate.esphome_web_6c4990_bedroom_mini_split";
                }
                {
                  type = "tile";
                  entity = "climate.esphome_web_6ab408_office_mini_split";
                }
              ];
            }
            {
              type = "entities";
              entities = [ "vacuum.s7_max_ultra" ];
            }
            {
              type = "entities";
              entities = [
                "select.s7_max_ultra_mop_intensity"
                "select.s7_max_ultra_mop_mode"
              ];
            }
            {
              type = "entities";
              entities = [
                { entity = "light.homelab_group_living_room_stairs"; }
                { entity = "light.homelab_group_upstairs_hallway"; }
                { entity = "light.homelab_group_office"; }
                { entity = "light.homelab_group_bedroom"; }
                { entity = "light.homelab_group_bedroom_closet"; }
                { entity = "light.homelab_group_bathroom_overhead"; }
                { entity = "light.homelab_group_bathroom_vanity"; }
              ];
            }
            {
              type = "entities";
              entities = [ "fan.0x048727fffe1b2e4d" ];
            }
          ];
        }
        {
          title = "Upstairs blinds";
          path = "upstairs-blinds";
          icon = "mdi:blinds";
          subview = true;
          badges = [ ];
          cards = [
            {
              type = "vertical-stack";
              cards = [
                {
                  features = [ { type = "cover-open-close"; } ];
                  type = "tile";
                  entity = "cover.homelab_zone_bathroom_big_shade";
                  name = "Bathroom big blind";
                }
                {
                  type = "tile";
                  entity = "cover.homelab_zone_bathroom_small_shade";
                  name = "Bathroom small blind";
                  features = [ { type = "cover-open-close"; } ];
                }
                {
                  features = [ { type = "cover-open-close"; } ];
                  type = "tile";
                  entity = "cover.homelab_zone_bedroom_small_shade";
                  name = "Bedroom small shade";
                }
                {
                  features = [ { type = "cover-open-close"; } ];
                  type = "tile";
                  entity = "cover.homelab_zone_bedroom_big_shade";
                  name = "Bedroom big shade";
                }
                {
                  type = "tile";
                  entity = "cover.homelab_zone_office_shade";
                  name = "Office";
                  features = [ { type = "cover-open-close"; } ];
                }
                {
                  type = "tile";
                  entity = "cover.homelab_zone_upstairs_hallway_shade";
                  name = "Hallway";
                  features = [ { type = "cover-open-close"; } ];
                }
              ];
            }
          ];
        }
      ];
    };
  };
}
