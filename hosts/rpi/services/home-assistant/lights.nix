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
          name = "Garage lights";
          entities = [
            "light.garage_ceiling_lights"
            "light.garage_desk_lights"
          ];
        }
        {
          platform = "group";
          name = "Garage ceiling lights";
          entities = [
            "light.homelab_zone_garage_light_1"
            "light.homelab_zone_garage_light_2"
            "light.homelab_zone_garage_light_3"
            "light.homelab_zone_garage_light_4"
            "light.homelab_zone_garage_light_5"
            "light.homelab_zone_garage_light_6"
          ];
        }
        {
          platform = "group";
          name = "Garage desk lights";
          entities = [
            "light.shapes_acf4"
            "light.jamie_ring_light"
          ];
        }
        {
          platform = "group";
          name = "Kitchen lights";
          entities = [
            "light.homelab_zone_kitchen_light_stairs"
            "light.homelab_zone_kitchen_light_1"
            "light.homelab_zone_kitchen_light_2"
            "light.homelab_zone_kitchen_light_3"
            "light.homelab_zone_kitchen_light_4"
          ];
        }
        {
          platform = "group";
          name = "Living room lights";
          entities = [
            "light.homelab_zone_living_room_light_stairs"
            "light.homelab_zone_living_room_light_1"
            "light.homelab_zone_living_room_light_2"
            "light.homelab_zone_living_room_light_3"
            "light.homelab_zone_living_room_light_4"
          ];
        }
        {
          platform = "group";
          name = "Downstairs lights";
          entities = [
            "light.kitchen_lights"
            "light.living_room_lights"
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
                entity_id = "light.garage_lights";
              };
              no_motion_wait = 1800;
            };
          };
        }
      ];

      adaptive_lighting = [
        {
          name = "Garage ceiling lights";
          lights = [
            "light.homelab_zone_garage_light_1"
            "light.homelab_zone_garage_light_2"
            "light.homelab_zone_garage_light_3"
            "light.homelab_zone_garage_light_4"
            "light.homelab_zone_garage_light_5"
            "light.homelab_zone_garage_light_6"
            "light.homelab_zone_garage_light_stairs"
          ];
          min_brightness = 100;
          min_color_temp = 2000;
          max_color_temp = 5500;
          interval = 30;
          detect_non_ha_changes = true;
        }
        {
          name = "Garage desk lights";
          lights = [
            "light.shapes_acf4"
            "light.jamie_ring_light"
          ];
          min_color_temp = 2000;
          max_color_temp = 5500;
          interval = 30;
          detect_non_ha_changes = true;
        }
        {
          name = "Downstairs lights";
          lights = [
            "light.homelab_zone_kitchen_light_stairs"
            "light.homelab_zone_kitchen_light_1"
            "light.homelab_zone_kitchen_light_2"
            "light.homelab_zone_kitchen_light_3"
            "light.homelab_zone_kitchen_light_4"
            "light.homelab_zone_living_room_light_stairs"
            "light.homelab_zone_living_room_light_1"
            "light.homelab_zone_living_room_light_2"
            "light.homelab_zone_living_room_light_3"
            "light.homelab_zone_living_room_light_4"
          ];
          min_brightness = 50;
          max_brightness = 100;
          min_color_temp = 3000;
          max_color_temp = 5500;
          interval = 30;
          detect_non_ha_changes = true;
        }
      ];
    };
  };
}
