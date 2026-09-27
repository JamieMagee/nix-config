{ lib, ... }:
let
  # Sources must contain only bulbs, not the switches' optimistic group states.
  switchSyncTargets = {
    balcony = {
      bulbEntity = "light.balcony_lights";
      switches = [ "light.kitchen_switch_balcony" ];
    };
    bathroom_overhead = {
      bulbEntity = "light.bathroom_overhead_lights";
      switches = [
        "light.bathroom_switch_overhead_1"
        "light.bathroom_switch_overhead_2"
      ];
    };
    bedroom = {
      bulbEntity = "light.bedroom_lights";
      switches = [ "light.bedroom_switch" ];
    };
    bedroom_closet = {
      bulbEntity = "light.bedroom_light_closet";
      switches = [ "light.bedroom_switch_closet" ];
    };
    front_porch = {
      bulbEntity = "light.front_porch_lights";
      switches = [ "light.living_room_switch_front_porch" ];
    };
    garage_indoors = {
      bulbEntity = "light.garage_indoors_lights";
      switches = [ "light.garage_switch_indoors" ];
    };
    garage_outdoor = {
      bulbEntity = "light.garage_outdoor_lights";
      switches = [ "light.garage_switch_outdoors" ];
    };
    kitchen = {
      bulbEntity = "light.kitchen_lights";
      switches = [
        "light.kitchen_switch_kitchen_light"
        "light.living_room_switch_kitchen_light"
      ];
    };
    living_room = {
      bulbEntity = "light.living_room_lights";
      switches = [
        "light.living_room_switch_living_room_light"
        "light.kitchen_switch_living_room_light"
      ];
    };
    living_room_stairs = {
      bulbEntity = "light.living_room_stairs_lights";
      switches = [
        "light.upstairs_switch_stairs_light"
        "light.living_room_switch_stairs_light"
      ];
    };
    office = {
      bulbEntity = "light.office_lights";
      switches = [ "light.office_switch" ];
    };
    rooftop = {
      bulbEntity = "light.rooftop_lights";
      switches = [ "light.upstairs_switch_rooftop" ];
    };
    # Preserve the original stair automation's identity.
    stair = {
      bulbEntity = "light.garage_kitchen_stairs_lights";
      switches = [
        "light.garage_hallway_switch_stairs"
        "light.kitchen_switch_stairs_light"
      ];
    };
  };

  mkSwitchSync =
    name:
    { bulbEntity, switches }:
    {
      alias = "Synchronize ${builtins.replaceStrings [ "_" ] [ " " ] name} switches with lights";
      id = "sync_${name}_switches_with_lights";
      description = "Mirror the bulbs when other controls bypass the shared Zigbee group.";
      mode = "restart";
      triggers = [
        {
          trigger = "state";
          entity_id = bulbEntity;
          to = "on";
        }
        {
          trigger = "state";
          entity_id = bulbEntity;
          to = "off";
        }
        {
          trigger = "homeassistant";
          event = "start";
        }
      ]
      ++
        map
          (to: {
            trigger = "state";
            entity_id = switches;
            inherit to;
            # Let direct bindings and switch ramps settle before correcting drift.
            for = {
              seconds = 3;
            };
          })
          [
            "on"
            "off"
          ];
      actions = map (entity_id: {
        choose =
          map
            (state: {
              conditions = [
                {
                  condition = "state";
                  entity_id = bulbEntity;
                  inherit state;
                }
                {
                  # Group updates are optimistic; explicitly confirm available switches.
                  condition = "or";
                  conditions =
                    map
                      (switchState: {
                        condition = "state";
                        inherit entity_id;
                        state = switchState;
                      })
                      [
                        "on"
                        "off"
                      ];
                }
              ];
              sequence = [
                {
                  action = "light.turn_${state}";
                  target = {
                    inherit entity_id;
                  };
                }
              ];
            })
            [
              "on"
              "off"
            ];
      }) switches;
    };
in
{
  services.home-assistant = {
    extraComponents = [
      "elgato"
      "nanoleaf"
    ];

    config = {
      light = [
        {
          platform = "group";
          name = "Garage desk lights";
          entities = [
            "light.shapes_acf4"
            "light.jamie_ring_light"
          ];
        }
      ];
      automation = lib.mapAttrsToList mkSwitchSync switchSyncTargets ++ [
        {
          alias = "Garage motion-activated lights";
          id = "garage_motion_lights";
          use_blueprint = {
            path = "homeassistant/motion_light.yaml";
            input = {
              motion_entity = "binary_sensor.garage_motion_occupancy";
              light_target = {
                entity_id = "light.garage_indoors";
              };
              no_motion_wait = 1800;
            };
          };
        }
        {
          alias = "Turn on outside lights at sunset";
          id = "turn_on_outside_lights";
          triggers = [
            {
              trigger = "sun";
              event = "sunset";
            }
          ];
          actions = [
            {
              action = "light.turn_on";
              target = {
                entity_id = [
                  "light.garage_outdoor_lights"
                  "light.front_porch_lights"
                  "light.balcony_lights"
                  "light.rooftop_string_lights"
                ];
              };
            }
          ];
        }
        {
          alias = "Turn off outside lights at sunrise";
          id = "turn_off_outside_lights";
          triggers = [
            {
              trigger = "sun";
              event = "sunrise";
            }
          ];
          actions = [
            {
              action = "light.turn_off";
              target = {
                entity_id = [
                  "light.garage_outdoor_lights"
                  "light.front_porch_lights"
                  "light.balcony_lights"
                  "light.rooftop_string_lights"
                ];
              };
            }
          ];
        }
        {
          alias = "Turn off rooftop string lights after dusk";
          id = "turn_off_rooftop_string_lights_after_dusk";
          description = "Turn off the Festavia one hour after civil dusk, with an 11 PM fallback.";
          triggers = [
            {
              trigger = "numeric_state";
              entity_id = "sun.sun";
              attribute = "elevation";
              below = -6;
              for = {
                hours = 1;
              };
            }
            {
              trigger = "time";
              at = "23:00:00";
            }
          ];
          actions = [
            {
              action = "light.turn_off";
              target = {
                entity_id = "light.rooftop_string_lights";
              };
            }
          ];
        }
        {
          alias = "Turn off indoor lights when no-one is home";
          id = "turn_off_indoor_lights";
          triggers = [
            {
              trigger = "state";
              entity_id = "zone.home";
              to = "0";
              for = {
                minutes = 1;
              };
            }
          ];
          actions = [
            {
              action = "light.turn_off";
              target = {
                entity_id = [
                  "light.indoor_lights"
                  "light.indoor_light_switches"
                ];
              };
            }
          ];
        }
        {
          alias = "Turn off front door outlet at night";
          id = "turn_off_front_door_outlet_night";
          triggers = [
            {
              trigger = "time";
              at = "22:00:00";
            }
          ];
          actions = [
            {
              action = "switch.turn_off";
              target = {
                entity_id = "switch.living_room_front_door_outlet";
              };
            }
          ];
        }
        {
          alias = "Turn on front door outlet in the morning";
          id = "turn_on_front_door_outlet_morning";
          triggers = [
            {
              trigger = "time";
              at = "06:00:00";
            }
          ];
          actions = [
            {
              action = "switch.turn_on";
              target = {
                entity_id = "switch.living_room_front_door_outlet";
              };
            }
          ];
        }
        {
          alias = "Turn off front door outlet when living room lights off";
          id = "turn_off_front_door_outlet_lights_off";
          triggers = [
            {
              trigger = "state";
              entity_id = "light.living_room_lights";
              to = "off";
            }
          ];
          actions = [
            {
              action = "switch.turn_off";
              target = {
                entity_id = "switch.living_room_front_door_outlet";
              };
            }
          ];
        }
        {
          alias = "Turn on front door outlet when living room lights on";
          id = "turn_on_front_door_outlet_lights_on";
          triggers = [
            {
              trigger = "state";
              entity_id = "light.living_room_lights";
              to = "on";
            }
          ];
          actions = [
            {
              action = "switch.turn_on";
              target = {
                entity_id = "switch.living_room_front_door_outlet";
              };
            }
          ];
        }
      ];

      adaptive_lighting = [
        {
          name = "Garage lights";
          lights = [
            "light.garage_indoors_lights"
          ];
          min_brightness = 100;
          intercept = true;
          take_over_control = true;
          detect_non_ha_changes = true;
          skip_redundant_commands = true;
        }
        {
          name = "Stair lights";
          lights = [
            "light.garage_kitchen_stairs_lights"
          ];
          min_brightness = 100;
          transition = 1;
          intercept = true;
          take_over_control = true;
          detect_non_ha_changes = true;
          skip_redundant_commands = true;
        }
        {
          name = "Jamie ring light";
          lights = [
            "light.jamie_ring_light"
          ];
          intercept = true;
          take_over_control = true;
          take_over_control_mode = "pause_changed";
          detect_non_ha_changes = true;
          skip_redundant_commands = true;
        }
        {
          name = "Garage Nanoleaf";
          lights = [
            "light.shapes_acf4"
          ];
          intercept = true;
          take_over_control = true;
          detect_non_ha_changes = true;
          skip_redundant_commands = true;
        }
        {
          name = "Indoor lights";
          lights = [
            "light.kitchen_lights"
            "light.living_room_lights"
            "light.living_room_stairs_lights"
            "light.office_lights"
            "light.upstairs_hallway_lights"
            "light.bedroom_lights"
            "light.bathroom_overhead_lights"
          ];
          min_brightness = 50;
          min_color_temp = 3000;
          intercept = true;
          take_over_control = true;
          detect_non_ha_changes = true;
          skip_redundant_commands = true;
        }
        {
          name = "Outside lights";
          lights = [
            "light.balcony_lights"
            "light.rooftop_lights"
            "light.front_porch_lights"
            "light.garage_outdoor_lights"
          ];
          min_brightness = 100;
          intercept = true;
          take_over_control = true;
          detect_non_ha_changes = true;
          skip_redundant_commands = true;
        }
      ];
    };
  };
}
