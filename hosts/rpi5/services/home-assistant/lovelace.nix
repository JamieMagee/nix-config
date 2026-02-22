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
        # ── Home ──────────────────────────────────────────
        {
          title = "Home";
          cards = [
            # Status bar
            {
              type = "custom:mushroom-chips-card";
              chips = [
                {
                  type = "weather";
                  entity = "weather.pirateweather";
                  show_conditions = true;
                  show_temperature = true;
                }
                {
                  type = "alarm-control-panel";
                  entity = "alarm_control_panel.abode_alarm";
                }
                {
                  type = "template";
                  icon = "mdi:door";
                  icon_color = "{{ 'red' if is_state('binary_sensor.doors', 'on') else 'green' }}";
                  content = "{{ 'Open' if is_state('binary_sensor.doors', 'on') else 'Secure' }}";
                  tap_action = {
                    action = "more-info";
                    entity = "binary_sensor.doors";
                  };
                }
                {
                  type = "template";
                  icon = "mdi:window-open-variant";
                  icon_color = "{{ 'red' if is_state('binary_sensor.windows', 'on') else 'green' }}";
                  content = "{{ 'Open' if is_state('binary_sensor.windows', 'on') else 'Closed' }}";
                  tap_action = {
                    action = "more-info";
                    entity = "binary_sensor.windows";
                  };
                }
                {
                  type = "template";
                  entity = "input_boolean.vacation_mode";
                  icon = "mdi:airplane";
                  icon_color = "{{ 'blue' if is_state('input_boolean.vacation_mode', 'on') else 'grey' }}";
                  content = "{{ 'Away' if is_state('input_boolean.vacation_mode', 'on') else '' }}";
                  tap_action = {
                    action = "toggle";
                  };
                }
              ];
            }

            # People
            {
              type = "horizontal-stack";
              cards = [
                {
                  type = "custom:mushroom-person-card";
                  entity = "person.jamie";
                  use_entity_picture = true;
                  layout = "horizontal";
                }
                {
                  type = "custom:mushroom-person-card";
                  entity = "person.kat";
                  use_entity_picture = true;
                  layout = "horizontal";
                }
              ];
            }

            # Weather
            {
              type = "weather-forecast";
              entity = "weather.pirateweather";
              show_current = true;
              show_forecast = true;
              forecast_type = "daily";
            }

            # Garbage
            {
              type = "custom:mushroom-entity-card";
              entity = "sensor.seattle_garbage_collection";
              name = "Garbage";
              icon = "mdi:trash-can";
            }

            # Areas
            {
              type = "custom:bubble-card";
              card_type = "separator";
              name = "Areas";
              icon = "mdi:floor-plan";
            }
            {
              type = "grid";
              columns = 3;
              square = false;
              cards = [
                {
                  type = "custom:mushroom-template-card";
                  primary = "Garage";
                  secondary = "{{ states('cover.garage_door') | title }}";
                  icon = "mdi:garage";
                  icon_color = "{{ 'orange' if is_state('cover.garage_door', 'open') else 'blue' }}";
                  badge_icon = "{{ 'mdi:arrow-up' if is_state('cover.garage_door', 'open') else '' }}";
                  badge_color = "orange";
                  tap_action = {
                    action = "navigate";
                    navigation_path = "/lovelace/garage";
                  };
                }
                {
                  type = "custom:mushroom-template-card";
                  primary = "Down";
                  secondary = "{{ state_attr('climate.esphome_web_6c37b0_downstairs_mini_split', 'current_temperature') | round(0) }}°";
                  icon = "mdi:home-floor-1";
                  icon_color = "{{ 'orange' if is_state('climate.esphome_web_6c37b0_downstairs_mini_split', 'heat') else 'blue' if is_state('climate.esphome_web_6c37b0_downstairs_mini_split', 'cool') else 'grey' }}";
                  badge_icon = "{{ 'mdi:lock' if is_state('lock.front_door', 'locked') else 'mdi:lock-open' }}";
                  badge_color = "{{ 'green' if is_state('lock.front_door', 'locked') else 'red' }}";
                  tap_action = {
                    action = "navigate";
                    navigation_path = "/lovelace/downstairs";
                  };
                }
                {
                  type = "custom:mushroom-template-card";
                  primary = "Up";
                  secondary = "{{ state_attr('climate.esphome_web_6c4990_bedroom_mini_split', 'current_temperature') | round(0) }}°";
                  icon = "mdi:home-floor-2";
                  icon_color = "{{ 'orange' if is_state('climate.esphome_web_6c4990_bedroom_mini_split', 'heat') else 'blue' if is_state('climate.esphome_web_6c4990_bedroom_mini_split', 'cool') else 'grey' }}";
                  badge_icon = "{{ 'mdi:robot-vacuum' if is_state('vacuum.s7_max_ultra', 'cleaning') else '' }}";
                  badge_color = "green";
                  tap_action = {
                    action = "navigate";
                    navigation_path = "/lovelace/upstairs";
                  };
                }
              ];
            }

            # Controls
            {
              type = "custom:bubble-card";
              card_type = "separator";
              name = "Controls";
              icon = "mdi:gesture-tap";
            }
            {
              type = "grid";
              columns = 3;
              square = false;
              cards = [
                {
                  type = "custom:mushroom-cover-card";
                  entity = "cover.garage_door";
                  name = "Garage";
                  layout = "vertical";
                  fill_container = true;
                  show_buttons_control = true;
                }
                {
                  type = "custom:mushroom-lock-card";
                  entity = "lock.front_door";
                  name = "Front Door";
                  layout = "vertical";
                  fill_container = true;
                }
                {
                  type = "custom:mushroom-template-card";
                  primary = "Lights Off";
                  icon = "mdi:lightbulb-group-off";
                  icon_color = "red";
                  layout = "vertical";
                  fill_container = true;
                  tap_action = {
                    action = "call-service";
                    service = "light.turn_off";
                    target = {
                      entity_id = "light.indoor_light_switches";
                    };
                  };
                }
              ];
            }

            # Appliance alerts (only when active)
            {
              type = "conditional";
              conditions = [
                {
                  entity = "sensor.washing_machine";
                  state_not = "idle";
                }
                {
                  entity = "sensor.washing_machine";
                  state_not = "off";
                }
                {
                  entity = "sensor.washing_machine";
                  state_not = "unavailable";
                }
              ];
              card = {
                type = "custom:mushroom-template-card";
                primary = "Washer";
                secondary = "{{ states('sensor.washing_machine') | replace('_', ' ') | title }}";
                icon = "mdi:washing-machine";
                icon_color = "blue";
                tap_action = {
                  action = "more-info";
                  entity = "sensor.washing_machine";
                };
              };
            }
            {
              type = "conditional";
              conditions = [
                {
                  entity = "sensor.tumble_dryer";
                  state_not = "idle";
                }
                {
                  entity = "sensor.tumble_dryer";
                  state_not = "off";
                }
                {
                  entity = "sensor.tumble_dryer";
                  state_not = "unavailable";
                }
              ];
              card = {
                type = "custom:mushroom-template-card";
                primary = "Dryer";
                secondary = "{{ states('sensor.tumble_dryer') | replace('_', ' ') | title }}";
                icon = "mdi:tumble-dryer";
                icon_color = "orange";
                tap_action = {
                  action = "more-info";
                  entity = "sensor.tumble_dryer";
                };
              };
            }

            # Cameras
            {
              type = "custom:bubble-card";
              card_type = "separator";
              name = "Cameras";
              icon = "mdi:cctv";
            }
            {
              type = "grid";
              columns = 2;
              square = false;
              cards = [
                {
                  type = "picture-entity";
                  entity = "camera.g4_doorbell_pro_high";
                  name = "Front Door";
                  show_name = true;
                  show_state = false;
                  camera_view = "live";
                }
                {
                  type = "picture-entity";
                  entity = "camera.g4_doorbell_pro_package_camera";
                  name = "Package";
                  show_name = true;
                  show_state = false;
                  camera_view = "live";
                }
              ];
            }
          ];
        }

        # ── Garage ────────────────────────────────────────
        {
          title = "Garage";
          path = "garage";
          icon = "mdi:garage";
          badges = [ ];
          cards = [
            # Door control
            {
              type = "custom:mushroom-cover-card";
              entity = "cover.garage_door";
              name = "Garage Door";
              show_buttons_control = true;
              show_position_control = false;
              layout = "horizontal";
            }

            # Status
            {
              type = "custom:mushroom-chips-card";
              chips = [
                {
                  type = "entity";
                  entity = "binary_sensor.garage_door";
                  name = "Door";
                  icon_color = "{{ 'red' if is_state('binary_sensor.garage_door', 'on') else 'green' }}";
                }
                {
                  type = "entity";
                  entity = "water_heater.heat_pump_water_heater";
                  name = "Water Heater";
                }
              ];
            }

            # Climate
            {
              type = "custom:bubble-card";
              card_type = "separator";
              name = "Climate";
              icon = "mdi:thermostat";
            }
            {
              type = "horizontal-stack";
              cards = [
                {
                  type = "custom:mushroom-climate-card";
                  entity = "climate.mysa_2bbd00_thermostat";
                  name = "Garage";
                  show_temperature_control = true;
                  layout = "vertical";
                  fill_container = true;
                }
                {
                  type = "custom:mushroom-climate-card";
                  entity = "climate.mysa_89501c_thermostat";
                  name = "Hallway";
                  show_temperature_control = true;
                  layout = "vertical";
                  fill_container = true;
                }
              ];
            }

            # Lighting
            {
              type = "custom:bubble-card";
              card_type = "separator";
              name = "Lighting";
              icon = "mdi:lightbulb-group";
            }
            {
              type = "grid";
              columns = 2;
              square = false;
              cards = [
                {
                  type = "custom:mushroom-light-card";
                  entity = "light.garage_switch_indoors";
                  name = "Indoor";
                  show_brightness_control = true;
                  layout = "vertical";
                  fill_container = true;
                }
                {
                  type = "custom:mushroom-light-card";
                  entity = "light.garage_bathroom_switch_light";
                  name = "Bathroom";
                  show_brightness_control = true;
                  layout = "vertical";
                  fill_container = true;
                }
                {
                  type = "custom:mushroom-light-card";
                  entity = "light.jamie_ring_light";
                  name = "Ring Light";
                  show_brightness_control = true;
                  layout = "vertical";
                  fill_container = true;
                }
                {
                  type = "custom:mushroom-light-card";
                  entity = "light.shapes_acf4";
                  name = "Nanoleaf";
                  show_brightness_control = true;
                  layout = "vertical";
                  fill_container = true;
                }
              ];
            }
          ];
        }

        # ── Downstairs ────────────────────────────────────
        {
          title = "Downstairs";
          path = "downstairs";
          icon = "mdi:home-floor-1";
          badges = [ ];
          cards = [
            # Security
            {
              type = "custom:bubble-card";
              card_type = "separator";
              name = "Security";
              icon = "mdi:shield-home";
            }
            {
              type = "custom:mushroom-lock-card";
              entity = "lock.front_door";
              name = "Front Door";
              layout = "horizontal";
            }
            {
              type = "custom:mushroom-chips-card";
              chips = [
                {
                  type = "entity";
                  entity = "binary_sensor.front_door";
                  name = "Door";
                  icon_color = "{{ 'red' if is_state('binary_sensor.front_door', 'on') else 'green' }}";
                }
                {
                  type = "entity";
                  entity = "binary_sensor.balcony_door";
                  name = "Balcony";
                  icon_color = "{{ 'red' if is_state('binary_sensor.balcony_door', 'on') else 'green' }}";
                }
                {
                  type = "entity";
                  entity = "binary_sensor.front_window";
                  name = "Window";
                  icon_color = "{{ 'red' if is_state('binary_sensor.front_window', 'on') else 'green' }}";
                }
              ];
            }

            # Climate
            {
              type = "custom:bubble-card";
              card_type = "separator";
              name = "Climate";
              icon = "mdi:thermostat";
            }
            {
              type = "custom:mushroom-climate-card";
              entity = "climate.esphome_web_6c37b0_downstairs_mini_split";
              name = "Mini Split";
              show_temperature_control = true;
              hvac_modes = [
                "heat_cool"
                "heat"
                "cool"
                "fan_only"
                "off"
              ];
              layout = "horizontal";
            }

            # Blinds
            {
              type = "custom:bubble-card";
              card_type = "separator";
              name = "Blinds";
              icon = "mdi:blinds";
            }
            {
              type = "custom:mushroom-chips-card";
              chips = [
                {
                  type = "template";
                  icon = "mdi:weather-sunny";
                  icon_color = "orange";
                  content = "Daytime";
                  tap_action = {
                    action = "call-service";
                    service = "scene.turn_on";
                    target = {
                      entity_id = "scene.downstairs_blinds_daytime";
                    };
                  };
                }
                {
                  type = "template";
                  icon = "mdi:blinds";
                  icon_color = "blue";
                  content = "Close";
                  tap_action = {
                    action = "call-service";
                    service = "cover.close_cover";
                    target = {
                      entity_id = "cover.downstairs_blinds";
                    };
                  };
                }
                {
                  type = "template";
                  icon = "mdi:blinds-open";
                  icon_color = "green";
                  content = "Open";
                  tap_action = {
                    action = "call-service";
                    service = "cover.open_cover";
                    target = {
                      entity_id = "cover.downstairs_blinds";
                    };
                  };
                }
                {
                  type = "template";
                  icon = "mdi:tune";
                  content = "Each";
                  tap_action = {
                    action = "navigate";
                    navigation_path = "/lovelace/downstairs-blinds";
                  };
                }
              ];
            }

            # Lighting
            {
              type = "custom:bubble-card";
              card_type = "separator";
              name = "Lighting";
              icon = "mdi:lightbulb-group";
            }
            {
              type = "grid";
              columns = 2;
              square = false;
              cards = [
                {
                  type = "custom:mushroom-light-card";
                  entity = "light.kitchen_switch_stairs_light";
                  name = "Kit. Stairs";
                  show_brightness_control = true;
                  layout = "vertical";
                  fill_container = true;
                }
                {
                  type = "custom:mushroom-light-card";
                  entity = "light.kitchen_switch_kitchen_light";
                  name = "Kitchen";
                  show_brightness_control = true;
                  layout = "vertical";
                  fill_container = true;
                }
                {
                  type = "custom:mushroom-light-card";
                  entity = "light.living_room_switch_living_room_light";
                  name = "Living Room";
                  show_brightness_control = true;
                  layout = "vertical";
                  fill_container = true;
                }
                {
                  type = "custom:mushroom-light-card";
                  entity = "light.living_room_switch_stairs_light";
                  name = "Liv. Stairs";
                  show_brightness_control = true;
                  layout = "vertical";
                  fill_container = true;
                }
              ];
            }
          ];
        }

        # ── Downstairs Blinds (subview) ───────────────────
        {
          title = "Downstairs Blinds";
          path = "downstairs-blinds";
          icon = "mdi:blinds";
          subview = true;
          badges = [ ];
          cards = [
            {
              type = "custom:mushroom-cover-card";
              entity = "cover.living_room_big_shade";
              name = "Front Window (Large)";
              show_buttons_control = true;
              show_position_control = true;
              layout = "horizontal";
            }
            {
              type = "custom:mushroom-cover-card";
              entity = "cover.living_room_small_shade";
              name = "Side Window (Small)";
              show_buttons_control = true;
              show_position_control = true;
              layout = "horizontal";
            }
            {
              type = "custom:mushroom-cover-card";
              entity = "cover.kitchen_shade";
              name = "Kitchen Window";
              show_buttons_control = true;
              show_position_control = true;
              layout = "horizontal";
            }
            {
              type = "custom:mushroom-chips-card";
              chips = [
                {
                  type = "template";
                  content = "Open All";
                  icon = "mdi:blinds-open";
                  tap_action = {
                    action = "call-service";
                    service = "cover.open_cover";
                    target = {
                      entity_id = "cover.downstairs_blinds";
                    };
                  };
                }
                {
                  type = "template";
                  content = "Close All";
                  icon = "mdi:blinds";
                  tap_action = {
                    action = "call-service";
                    service = "cover.close_cover";
                    target = {
                      entity_id = "cover.downstairs_blinds";
                    };
                  };
                }
                {
                  type = "template";
                  content = "Daytime";
                  icon = "mdi:weather-sunny";
                  tap_action = {
                    action = "call-service";
                    service = "scene.turn_on";
                    target = {
                      entity_id = "scene.downstairs_blinds_daytime";
                    };
                  };
                }
              ];
            }
          ];
        }

        # ── Upstairs ──────────────────────────────────────
        {
          title = "Upstairs";
          path = "upstairs";
          icon = "mdi:home-floor-2";
          badges = [ ];
          cards = [
            # Climate
            {
              type = "custom:bubble-card";
              card_type = "separator";
              name = "Climate";
              icon = "mdi:thermostat";
            }
            {
              type = "horizontal-stack";
              cards = [
                {
                  type = "custom:mushroom-climate-card";
                  entity = "climate.esphome_web_6c4990_bedroom_mini_split";
                  name = "Bedroom";
                  show_temperature_control = true;
                  hvac_modes = [
                    "heat_cool"
                    "heat"
                    "cool"
                    "fan_only"
                    "off"
                  ];
                  layout = "vertical";
                  fill_container = true;
                }
                {
                  type = "custom:mushroom-climate-card";
                  entity = "climate.esphome_web_6ab408_office_mini_split";
                  name = "Office";
                  show_temperature_control = true;
                  hvac_modes = [
                    "heat_cool"
                    "heat"
                    "cool"
                    "fan_only"
                    "off"
                  ];
                  layout = "vertical";
                  fill_container = true;
                }
              ];
            }

            # Blinds
            {
              type = "custom:bubble-card";
              card_type = "separator";
              name = "Blinds";
              icon = "mdi:blinds";
            }
            {
              type = "custom:mushroom-chips-card";
              chips = [
                {
                  type = "template";
                  icon = "mdi:weather-sunny";
                  icon_color = "orange";
                  content = "Daytime";
                  tap_action = {
                    action = "call-service";
                    service = "scene.turn_on";
                    target = {
                      entity_id = "scene.upstairs_blinds_daytime";
                    };
                  };
                }
                {
                  type = "template";
                  icon = "mdi:blinds";
                  icon_color = "blue";
                  content = "Close";
                  tap_action = {
                    action = "call-service";
                    service = "cover.close_cover";
                    target = {
                      entity_id = "cover.upstairs_blinds";
                    };
                  };
                }
                {
                  type = "template";
                  icon = "mdi:blinds-open";
                  icon_color = "green";
                  content = "Open";
                  tap_action = {
                    action = "call-service";
                    service = "cover.open_cover";
                    target = {
                      entity_id = "cover.upstairs_blinds";
                    };
                  };
                }
                {
                  type = "template";
                  icon = "mdi:tune";
                  content = "Each";
                  tap_action = {
                    action = "navigate";
                    navigation_path = "/lovelace/upstairs-blinds";
                  };
                }
              ];
            }

            # Cleaning
            {
              type = "custom:bubble-card";
              card_type = "separator";
              name = "Cleaning";
              icon = "mdi:robot-vacuum";
            }
            {
              type = "custom:mushroom-vacuum-card";
              entity = "vacuum.s7_max_ultra";
              name = "Robot Vacuum";
              commands = [
                "start_pause"
                "stop"
                "locate"
                "return_home"
              ];
              layout = "horizontal";
            }
            {
              type = "horizontal-stack";
              cards = [
                {
                  type = "custom:mushroom-select-card";
                  entity = "select.s7_max_ultra_mop_intensity";
                  name = "Mop";
                  layout = "horizontal";
                  fill_container = true;
                }
                {
                  type = "custom:mushroom-select-card";
                  entity = "select.s7_max_ultra_mop_mode";
                  name = "Mode";
                  layout = "horizontal";
                  fill_container = true;
                }
              ];
            }

            # Lighting
            {
              type = "custom:bubble-card";
              card_type = "separator";
              name = "Lighting";
              icon = "mdi:lightbulb-group";
            }
            {
              type = "grid";
              columns = 2;
              square = false;
              cards = [
                {
                  type = "custom:mushroom-light-card";
                  entity = "light.kat_ring_light";
                  name = "Kat's Light";
                  show_brightness_control = true;
                  layout = "vertical";
                  fill_container = true;
                }
                {
                  type = "custom:mushroom-light-card";
                  entity = "light.living_room_stairs";
                  name = "Stairs";
                  show_brightness_control = true;
                  layout = "vertical";
                  fill_container = true;
                }
                {
                  type = "custom:mushroom-light-card";
                  entity = "light.upstairs_hallway";
                  name = "Hallway";
                  show_brightness_control = true;
                  layout = "vertical";
                  fill_container = true;
                }
                {
                  type = "custom:mushroom-light-card";
                  entity = "light.office";
                  name = "Office";
                  show_brightness_control = true;
                  layout = "vertical";
                  fill_container = true;
                }
                {
                  type = "custom:mushroom-light-card";
                  entity = "light.bedroom";
                  name = "Bedroom";
                  show_brightness_control = true;
                  layout = "vertical";
                  fill_container = true;
                }
                {
                  type = "custom:mushroom-light-card";
                  entity = "light.bedroom_closet";
                  name = "Closet";
                  show_brightness_control = true;
                  layout = "vertical";
                  fill_container = true;
                }
                {
                  type = "custom:mushroom-light-card";
                  entity = "light.bathroom_overhead";
                  name = "Bathroom";
                  show_brightness_control = true;
                  layout = "vertical";
                  fill_container = true;
                }
                {
                  type = "custom:mushroom-light-card";
                  entity = "light.bathroom_vanity";
                  name = "Vanity";
                  show_brightness_control = true;
                  layout = "vertical";
                  fill_container = true;
                }
              ];
            }

            # Ventilation
            {
              type = "custom:bubble-card";
              card_type = "separator";
              name = "Ventilation";
              icon = "mdi:fan";
            }
            {
              type = "custom:mushroom-fan-card";
              entity = "fan.bathroom_fan";
              name = "Bathroom Fan";
              show_percentage_control = true;
              show_oscillate_control = false;
              layout = "horizontal";
            }
          ];
        }

        # ── Upstairs Blinds (subview) ─────────────────────
        {
          title = "Upstairs Blinds";
          path = "upstairs-blinds";
          icon = "mdi:blinds";
          subview = true;
          badges = [ ];
          cards = [
            {
              type = "custom:mushroom-cover-card";
              entity = "cover.bathroom_big_shade";
              name = "Bathroom (Large)";
              show_buttons_control = true;
              show_position_control = true;
              layout = "horizontal";
            }
            {
              type = "custom:mushroom-cover-card";
              entity = "cover.bathroom_small_shade";
              name = "Bathroom (Small)";
              show_buttons_control = true;
              show_position_control = true;
              layout = "horizontal";
            }
            {
              type = "custom:mushroom-cover-card";
              entity = "cover.bedroom_small_shade";
              name = "Bedroom (Small)";
              show_buttons_control = true;
              show_position_control = true;
              layout = "horizontal";
            }
            {
              type = "custom:mushroom-cover-card";
              entity = "cover.bedroom_big_shade";
              name = "Bedroom (Large)";
              show_buttons_control = true;
              show_position_control = true;
              layout = "horizontal";
            }
            {
              type = "custom:mushroom-cover-card";
              entity = "cover.office_shade";
              name = "Office";
              show_buttons_control = true;
              show_position_control = true;
              layout = "horizontal";
            }
            {
              type = "custom:mushroom-cover-card";
              entity = "cover.upstairs_hallway_shade";
              name = "Hallway";
              show_buttons_control = true;
              show_position_control = true;
              layout = "horizontal";
            }
            {
              type = "custom:mushroom-chips-card";
              chips = [
                {
                  type = "template";
                  content = "Open All";
                  icon = "mdi:blinds-open";
                  tap_action = {
                    action = "call-service";
                    service = "cover.open_cover";
                    target = {
                      entity_id = "cover.upstairs_blinds";
                    };
                  };
                }
                {
                  type = "template";
                  content = "Close All";
                  icon = "mdi:blinds";
                  tap_action = {
                    action = "call-service";
                    service = "cover.close_cover";
                    target = {
                      entity_id = "cover.upstairs_blinds";
                    };
                  };
                }
                {
                  type = "template";
                  content = "Daytime";
                  icon = "mdi:weather-sunny";
                  tap_action = {
                    action = "call-service";
                    service = "scene.turn_on";
                    target = {
                      entity_id = "scene.upstairs_blinds_daytime";
                    };
                  };
                }
              ];
            }
          ];
        }
      ];
    };
  };
}
