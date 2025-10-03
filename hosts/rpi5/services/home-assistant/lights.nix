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
              motion_entity = "binary_sensor.garage_motion_occupancy";
              light_target = {
                entity_id = "light.garage_indoors_lights";
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
                  "light.indoor_light_switches"
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
            "light.garage_indoors_lights"
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
            "light.garage_stairs"
            "light.kitchen"
            "light.living_room"
            "light.living_room_stairs_lights"
            "light.office_lights"
            "light.upstairs_hallway_lights"
            "light.bedroom_lights"
            "light.bathroom_overhead_lights"
          ];
          min_brightness = 50;
          min_color_temp = 3000;
          detect_non_ha_changes = true;
        }
        {
          name = "Outside lights";
          lights = [
            "light.balcony"
            "light.rooftop"
            "light.front_porch"
            "light.garage_outdoor"
          ];
          min_brightness = 100;
          detect_non_ha_changes = true;
        }
      ];
    };
  };
}
