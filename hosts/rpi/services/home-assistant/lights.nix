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
            "light.homelab_zone_garage_light_1"
            "light.homelab_zone_garage_light_2"
            "light.homelab_zone_garage_light_3"
            "light.homelab_zone_garage_light_4"
            "light.homelab_zone_garage_light_5"
            "light.homelab_zone_garage_light_6"
            "light.elgato_dw33j1a09337"
            "light.kat_ring_light"
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
            "light.elgato_dw33j1a09337"
            "light.kat_ring_light"
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
                area_id = "garage";
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
            "light.garage_ceiling_lights"
          ];
          min_brightness = 100;
          min_color_temp = 2000;
          max_color_temp = 5500;
          interval = 30;
        }
        {
          name = "Garage desk lights";
          lights = [
            "light.garage_desk_lights"
          ];
          min_color_temp = 2000;
          max_color_temp = 5500;
          interval = 30;
        }
      ];
    };
  };
}
