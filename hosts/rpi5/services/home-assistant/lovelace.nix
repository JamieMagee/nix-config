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
            # Header Section
            {
              type = "custom:mushroom-title-card";
              title = "Welcome Home";
              subtitle = "{{ now().strftime('%A, %B %d') }}";
            }

            # Weather & Quick Status
            {
              type = "horizontal-stack";
              cards = [
                {
                  type = "weather-forecast";
                  entity = "weather.forecast_home";
                  show_current = true;
                  show_forecast = true;
                  forecast_type = "daily";
                }
                {
                  type = "vertical-stack";
                  cards = [
                    {
                      type = "custom:mushroom-chips-card";
                      chips = [
                        {
                          type = "alarm-control-panel";
                          entity = "alarm_control_panel.abode_alarm";
                          name = "Security";
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
                          icon = "mdi:airplane";
                          icon_color = "{{ 'blue' if is_state('input_boolean.vacation_mode', 'on') else 'grey' }}";
                          content = "{{ 'Active' if is_state('input_boolean.vacation_mode', 'on') else 'Home' }}";
                          tap_action = {
                            action = "toggle";
                            entity = "input_boolean.vacation_mode";
                          };
                        }
                      ];
                    }
                    {
                      type = "custom:mushroom-entity-card";
                      entity = "sensor.seattle_garbage_collection";
                      name = "Garbage Collection";
                      icon = "mdi:trash-can";
                    }
                  ];
                }
              ];
            }

            # People Section
            {
              type = "custom:mushroom-title-card";
              title = "Family";
            }
            {
              type = "horizontal-stack";
              cards = [
                {
                  type = "custom:mushroom-person-card";
                  entity = "person.jamie";
                  use_entity_picture = true;
                  layout = "vertical";
                }
                {
                  type = "custom:mushroom-person-card";
                  entity = "person.kat";
                  use_entity_picture = true;
                  layout = "vertical";
                }
              ];
            }

            # Navigation Section
            {
              type = "custom:mushroom-title-card";
              title = "Areas";
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
                  badge_icon = "{{ 'mdi:arrow-up' if is_state('cover.garage_door', 'open') else 'mdi:arrow-down' }}";
                  badge_color = "{{ 'orange' if is_state('cover.garage_door', 'open') else 'green' }}";
                  tap_action = {
                    action = "navigate";
                    navigation_path = "/lovelace/garage";
                  };
                  hold_action = {
                    action = "toggle";
                    entity = "cover.garage_door";
                  };
                }
                {
                  type = "custom:mushroom-template-card";
                  primary = "Downstairs";
                  secondary = "{{ states('climate.esphome_web_6c37b0_downstairs_mini_split', 'temperature') }}°";
                  icon = "mdi:home-floor-1";
                  icon_color = "blue";
                  badge_icon = "{{ 'mdi:lock' if is_state('lock.front_door', 'locked') else 'mdi:lock-open' }}";
                  badge_color = "{{ 'green' if is_state('lock.front_door', 'locked') else 'red' }}";
                  tap_action = {
                    action = "navigate";
                    navigation_path = "/lovelace/downstairs";
                  };
                }
                {
                  type = "custom:mushroom-template-card";
                  primary = "Upstairs";
                  secondary = "{{ states('climate.esphome_web_6c4990_bedroom_mini_split', 'temperature') }}°";
                  icon = "mdi:home-floor-2";
                  icon_color = "blue";
                  badge_icon = "{{ 'mdi:robot-vacuum' if is_state('vacuum.s7_max_ultra', 'cleaning') else '' }}";
                  badge_color = "green";
                  tap_action = {
                    action = "navigate";
                    navigation_path = "/lovelace/upstairs";
                  };
                }
              ];
            }

            # Quick Controls Section
            {
              type = "custom:mushroom-title-card";
              title = "Quick Controls";
            }
            {
              type = "horizontal-stack";
              cards = [
                {
                  type = "custom:mushroom-cover-card";
                  entity = "cover.garage_door";
                  name = "Garage Door";
                  layout = "vertical";
                  fill_container = false;
                  show_buttons_control = true;
                }
                {
                  type = "custom:mushroom-lock-card";
                  entity = "lock.front_door";
                  name = "Front Door";
                  layout = "vertical";
                  fill_container = false;
                }
              ];
            }

            # Appliance Monitoring
            {
              type = "custom:mushroom-title-card";
              title = "Appliances";
            }
            {
              type = "horizontal-stack";
              cards = [
                {
                  type = "custom:mushroom-template-card";
                  primary = "Washing Machine";
                  secondary = "{{ states('sensor.washing_machine') }}";
                  icon = "mdi:washing-machine";
                  icon_color = "{{ 'green' if is_state('sensor.washing_machine', 'idle') else 'blue' }}";
                  tap_action = {
                    action = "more-info";
                    entity = "sensor.washing_machine";
                  };
                }
                {
                  type = "custom:mushroom-template-card";
                  primary = "Tumble Dryer";
                  secondary = "{{ states('sensor.tumble_dryer') }}";
                  icon = "mdi:tumble-dryer";
                  icon_color = "{{ 'green' if is_state('sensor.tumble_dryer', 'idle') else 'orange' }}";
                  tap_action = {
                    action = "more-info";
                    entity = "sensor.tumble_dryer";
                  };
                }
              ];
            }

            # Security Cameras
            {
              type = "custom:mushroom-title-card";
              title = "Security";
            }
            {
              type = "grid";
              columns = 1;
              square = false;
              cards = [
                {
                  type = "picture-entity";
                  entity = "camera.g4_doorbell_pro_high";
                  name = "Front Door Camera";
                  show_name = true;
                  show_state = true;
                  camera_view = "live";
                }
                {
                  type = "picture-entity";
                  entity = "camera.g4_doorbell_pro_package_camera";
                  name = "Package Camera";
                  show_name = true;
                  show_state = true;
                  camera_view = "live";
                }
              ];
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
              type = "custom:mushroom-title-card";
              title = "Garage";
              subtitle = "Controls and monitoring";
            }

            # Main Garage Control
            {
              type = "custom:mushroom-cover-card";
              entity = "cover.garage_door";
              name = "Garage Door";
              show_buttons_control = true;
              show_position_control = false;
              layout = "horizontal";
            }

            # Status Indicators
            {
              type = "custom:mushroom-chips-card";
              chips = [
                {
                  type = "entity";
                  entity = "binary_sensor.garage_door";
                  name = "Door Sensor";
                  icon_color = "{{ 'red' if is_state('binary_sensor.garage_door', 'on') else 'green' }}";
                }
                {
                  type = "entity";
                  entity = "water_heater.heat_pump_water_heater";
                  name = "Water Heater";
                }
              ];
            }

            # Climate Control
            {
              type = "custom:mushroom-title-card";
              title = "Climate";
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
                  fill_container = false;
                }
                {
                  type = "custom:mushroom-climate-card";
                  entity = "climate.mysa_89501c_thermostat";
                  name = "Downstairs";
                  show_temperature_control = true;
                  layout = "vertical";
                  fill_container = false;
                }
              ];
            }

            # Lighting
            {
              type = "custom:mushroom-title-card";
              title = "Lighting";
            }
            {
              type = "grid";
              columns = 2;
              square = false;
              cards = [
                {
                  type = "custom:mushroom-light-card";
                  entity = "light.garage_switch_indoors";
                  name = "Indoor Lights";
                  show_brightness_control = true;
                  layout = "vertical";
                  fill_container = false;
                }
                {
                  type = "custom:mushroom-light-card";
                  entity = "light.garage_bathroom_switch_light";
                  name = "Bathroom";
                  show_brightness_control = true;
                  layout = "vertical";
                  fill_container = false;
                }
                {
                  type = "custom:mushroom-light-card";
                  entity = "light.jamie_ring_light";
                  name = "Ring Light";
                  show_brightness_control = true;
                  layout = "vertical";
                  fill_container = false;
                }
                {
                  type = "custom:mushroom-light-card";
                  entity = "light.shapes_acf4";
                  name = "Shapes";
                  show_brightness_control = true;
                  layout = "vertical";
                  fill_container = false;
                }
              ];
            }
          ];
        }
        {
          subview = false;
          title = "Downstairs";
          path = "downstairs";
          icon = "mdi:home-floor-1";
          badges = [ ];
          cards = [
            {
              type = "custom:mushroom-title-card";
              title = "Downstairs";
              subtitle = "Living areas and entry";
            }

            # Security & Access
            {
              type = "custom:mushroom-title-card";
              title = "Security & Access";
            }
            {
              type = "horizontal-stack";
              cards = [
                {
                  type = "custom:mushroom-lock-card";
                  entity = "lock.front_door";
                  name = "Front Door";
                  layout = "vertical";
                  fill_container = false;
                }
                {
                  type = "custom:mushroom-chips-card";
                  chips = [
                    {
                      type = "entity";
                      entity = "binary_sensor.front_door";
                      name = "Front Door";
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
              ];
            }

            # Climate Control
            {
              type = "custom:mushroom-title-card";
              title = "Climate";
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

            # Blinds Control
            {
              type = "custom:mushroom-title-card";
              title = "Blinds";
            }
            {
              type = "horizontal-stack";
              cards = [
                {
                  type = "custom:mushroom-template-card";
                  primary = "Daytime Scene";
                  secondary = "Open blinds for day";
                  icon = "mdi:blinds-open";
                  icon_color = "orange";
                  tap_action = {
                    action = "call-service";
                    service = "scene.turn_on";
                    target = {
                      entity_id = "scene.downstairs_blinds_daytime";
                    };
                  };
                }
                {
                  type = "custom:mushroom-template-card";
                  primary = "Close All";
                  secondary = "Close all blinds";
                  icon = "mdi:blinds";
                  icon_color = "blue";
                  tap_action = {
                    action = "call-service";
                    service = "cover.close_cover";
                    target = {
                      entity_id = "cover.downstairs_blinds";
                    };
                  };
                }
                {
                  type = "custom:mushroom-template-card";
                  primary = "Individual";
                  secondary = "Control each blind";
                  icon = "mdi:tune";
                  icon_color = "green";
                  tap_action = {
                    action = "navigate";
                    navigation_path = "/lovelace/downstairs-blinds";
                  };
                }
              ];
            }

            # Lighting
            {
              type = "custom:mushroom-title-card";
              title = "Lighting";
            }
            {
              type = "grid";
              columns = 2;
              square = false;
              cards = [
                {
                  type = "custom:mushroom-light-card";
                  entity = "light.switch_stairs_light";
                  name = "Kitchen Stairs";
                  show_brightness_control = true;
                  layout = "vertical";
                  fill_container = false;
                }
                {
                  type = "custom:mushroom-light-card";
                  entity = "light.kitchen_switch_kitchen_light";
                  name = "Kitchen";
                  show_brightness_control = true;
                  layout = "vertical";
                  fill_container = false;
                }
                {
                  type = "custom:mushroom-light-card";
                  entity = "light.living_room_switch_living_room_light";
                  name = "Living Room";
                  show_brightness_control = true;
                  layout = "vertical";
                  fill_container = false;
                }
                {
                  type = "custom:mushroom-light-card";
                  entity = "light.living_room_switch_stairs_light";
                  name = "Living Stairs";
                  show_brightness_control = true;
                  layout = "vertical";
                  fill_container = false;
                }
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
              type = "custom:mushroom-title-card";
              title = "Downstairs Blinds";
              subtitle = "Individual blind controls";
            }

            {
              type = "grid";
              columns = 1;
              square = false;
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
              ];
            }

            # Quick Actions
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
        {
          title = "Upstairs";
          path = "upstairs";
          icon = "mdi:home-floor-2";
          subview = false;
          badges = [ ];
          cards = [
            {
              type = "custom:mushroom-title-card";
              title = "Upstairs";
              subtitle = "Bedrooms, office and bathroom";
            }

            # Climate Control
            {
              type = "custom:mushroom-title-card";
              title = "Climate";
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
                  fill_container = false;
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
                  fill_container = false;
                }
              ];
            }

            # Blinds Control
            {
              type = "custom:mushroom-title-card";
              title = "Blinds";
            }
            {
              type = "horizontal-stack";
              cards = [
                {
                  type = "custom:mushroom-template-card";
                  primary = "Daytime Scene";
                  secondary = "Open blinds for day";
                  icon = "mdi:blinds-open";
                  icon_color = "orange";
                  tap_action = {
                    action = "call-service";
                    service = "scene.turn_on";
                    target = {
                      entity_id = "scene.upstairs_blinds_daytime";
                    };
                  };
                }
                {
                  type = "custom:mushroom-template-card";
                  primary = "Close All";
                  secondary = "Close all blinds";
                  icon = "mdi:blinds";
                  icon_color = "blue";
                  tap_action = {
                    action = "call-service";
                    service = "cover.close_cover";
                    target = {
                      entity_id = "cover.upstairs_blinds";
                    };
                  };
                }
                {
                  type = "custom:mushroom-template-card";
                  primary = "Individual";
                  secondary = "Control each blind";
                  icon = "mdi:tune";
                  icon_color = "green";
                  tap_action = {
                    action = "navigate";
                    navigation_path = "/lovelace/upstairs-blinds";
                  };
                }
              ];
            }

            # Vacuum Control
            {
              type = "custom:mushroom-title-card";
              title = "Cleaning";
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
              fill_container = false;
            }
            {
              type = "horizontal-stack";
              cards = [
                {
                  type = "custom:mushroom-select-card";
                  entity = "select.s7_max_ultra_mop_intensity";
                  name = "Mop Intensity";
                  layout = "vertical";
                  fill_container = false;
                }
                {
                  type = "custom:mushroom-select-card";
                  entity = "select.s7_max_ultra_mop_mode";
                  name = "Mop Mode";
                  layout = "vertical";
                  fill_container = false;
                }
              ];
            }

            # Lighting
            {
              type = "custom:mushroom-title-card";
              title = "Lighting";
            }
            {
              type = "grid";
              columns = 2;
              square = false;
              cards = [
                {
                  type = "custom:mushroom-light-card";
                  entity = "light.kat_ring_light";
                  name = "Kat's Ring Light";
                  show_brightness_control = true;
                  layout = "vertical";
                  fill_container = false;
                }
                {
                  type = "custom:mushroom-light-card";
                  entity = "light.living_room_stairs";
                  name = "Stairs";
                  show_brightness_control = true;
                  layout = "vertical";
                  fill_container = false;
                }
                {
                  type = "custom:mushroom-light-card";
                  entity = "light.upstairs_hallway";
                  name = "Hallway";
                  show_brightness_control = true;
                  layout = "vertical";
                  fill_container = false;
                }
                {
                  type = "custom:mushroom-light-card";
                  entity = "light.office";
                  name = "Office";
                  show_brightness_control = true;
                  layout = "vertical";
                  fill_container = false;
                }
                {
                  type = "custom:mushroom-light-card";
                  entity = "light.bedroom";
                  name = "Bedroom";
                  show_brightness_control = true;
                  layout = "vertical";
                  fill_container = false;
                }
                {
                  type = "custom:mushroom-light-card";
                  entity = "light.bedroom_closet";
                  name = "Closet";
                  show_brightness_control = true;
                  layout = "vertical";
                  fill_container = false;
                }
                {
                  type = "custom:mushroom-light-card";
                  entity = "light.bathroom_overhead";
                  name = "Bathroom";
                  show_brightness_control = true;
                  layout = "vertical";
                  fill_container = false;
                }
                {
                  type = "custom:mushroom-light-card";
                  entity = "light.bathroom_vanity";
                  name = "Vanity";
                  show_brightness_control = true;
                  layout = "vertical";
                  fill_container = false;
                }
              ];
            }

            # Fans
            {
              type = "custom:mushroom-title-card";
              title = "Ventilation";
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
        {
          title = "Upstairs blinds";
          path = "upstairs-blinds";
          icon = "mdi:blinds";
          subview = true;
          badges = [ ];
          cards = [
            {
              type = "custom:mushroom-title-card";
              title = "Upstairs Blinds";
              subtitle = "Individual blind controls";
            }

            {
              type = "grid";
              columns = 1;
              square = false;
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
              ];
            }

            # Quick Actions
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
