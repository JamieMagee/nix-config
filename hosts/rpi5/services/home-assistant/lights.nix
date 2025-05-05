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
      automation = [
        {
          alias = "Garage motion-activated lights";
          id = "garage_motion_lights";
          use_blueprint = {
            path = "homeassistant/motion_light.yaml";
            input = {
              motion_entity = "binary_sensor.homelab_zone_garage_motion_occupancy";
              light_target = {
                entity_id = "light.homelab_group_garage_indoors_lights";
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
                  "light.homelab_group_garage_outdoor_lights"
                  "light.homelab_group_front_porch_lights"
                  "light.homelab_group_balcony_lights"
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
                  "light.homelab_group_garage_outdoor_lights"
                  "light.homelab_group_front_porch_lights"
                  "light.homelab_group_balcony_lights"
                ];
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
                  "light.homelab_group_indoor_light_switches"
                ];
              };
            }
          ];
        }
      ];

      adaptive_lighting = [
        {
          name = "Garage lights";
          lights = [
            "light.homelab_group_garage_indoors_lights"
          ];
          min_brightness = 100;
          detect_non_ha_changes = true;
        }
        {
          name = "Garage desk lights";
          lights = [
            "light.shapes_acf4"
            "light.jamie_ring_light"
          ];
          detect_non_ha_changes = true;
        }
        {
          name = "Indoor lights";
          lights = [
            "light.homelab_group_garage_stairs"
            "light.homelab_group_kitchen"
            "light.homelab_group_living_room"
            "light.homelab_group_living_room_stairs_lights"
            "light.homelab_group_office_lights"
            "light.homelab_group_upstairs_hallway_lights"
            "light.homelab_group_bedroom_lights"
            "light.homelab_group_bathroom_overhead_lights"
          ];
          min_brightness = 50;
          min_color_temp = 3000;
          detect_non_ha_changes = true;
        }
        {
          name = "Outside lights";
          lights = [
            "light.homelab_group_balcony"
            "light.homelab_group_rooftop"
            "light.homelab_group_front_porch"
            "light.homelab_group_garage_outdoor"
          ];
          min_brightness = 100;
          detect_non_ha_changes = true;
        }
      ];
    };
  };
}
