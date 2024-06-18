{
  services.home-assistant.config = {
    cover = [
      {
        platform = "group";
        name = "All blinds";
        entities = [
          "cover.homelab_zone_living_room_big_shade"
          "cover.homelab_zone_living_room_small_shade"
          "cover.homelab_zone_kitchen_shade"
          # "cover.homelab_zone_bedroom_big_shade"
          # "cover.homelab_zone_bedroom_small_shade"
          "cover.homelab_zone_office_shade"
          "cover.homelab_zone_bathroom_big_shade"
          "cover.homelab_zone_bathroom_small_shade"
          "cover.homelab_zone_upstairs_hallway_shade"
        ];
      }
      {
        platform = "group";
        name = "Downstairs blinds";
        entities = [
          "cover.homelab_zone_living_room_big_shade"
          "cover.homelab_zone_living_room_small_shade"
          "cover.homelab_zone_kitchen_shade"
        ];
      }
      {
        platform = "group";
        name = "Upstairs blinds";
        entities = [
          # "cover.homelab_zone_bedroom_big_shade"
          # "cover.homelab_zone_bedroom_small_shade"
          "cover.homelab_zone_office_shade"
          "cover.homelab_zone_bathroom_big_shade"
          "cover.homelab_zone_bathroom_small_shade"
          "cover.homelab_zone_upstairs_hallway_shade"
        ];
      }
      {
        platform = "group";
        name = "Bedroom blinds";
        entities = [
          # "cover.homelab_zone_bedroom_big_shade"
          # "cover.homelab_zone_bedroom_small_shade"
        ];
      }
      {
        platform = "group";
        name = "Bathroom blinds";
        entities = [
          "cover.homelab_zone_bathroom_big_shade"
          "cover.homelab_zone_bathroom_small_shade"
        ];
      }
    ];

    scene = [
      {
        name = "Downstairs blinds daytime";
        icon = "mdi:blinds";
        entities = {
          "cover.homelab_zone_living_room_big_shade" = {
            current_position = 2;
            state = "open";
          };
          "cover.homelab_zone_living_room_small_shade" = {
            current_position = 2;
            state = "open";
          };
          "cover.homelab_zone_kitchen_shade" = {
            current_position = 4;
            state = "open";
          };
        };
      }
      {
        name = "Upstairs blinds daytime";
        icon = "mdi:blinds";
        entities = {
          "cover.homelab_zone_office_shade" = {
            current_position = 100;
            state = "open";
          };
          "cover.homelab_zone_bathroom_big_shade" = {
            current_position = 100;
            state = "open";
          };
          "cover.homelab_zone_bathroom_small_shade" = {
            current_position = 100;
            state = "open";
          };
          "cover.homelab_zone_upstairs_hallway_shade" = {
            current_position = 100;
            state = "open";
          };
        };
      }
      {
        name = "Morning blinds";
        icon = "mdi:blinds";
        entities = {
          "cover.homelab_zone_bathroom_big_shade" = {
            current_position = 100;
            state = "open";
          };
          "cover.homelab_zone_bathroom_small_shade" = {
            current_position = 100;
            state = "open";
          };
          "cover.homelab_zone_upstairs_hallway_shade" = {
            current_position = 100;
            state = "open";
          };
        };
      }
    ];

    automation = [
      {
        alias = "Close blinds at sunset";
        id = "close_blinds_sunset";
        trigger = [
          {
            platform = "sun";
            event = "sunset";
          }
          {
            platform = "time";
            at = "18:00";
          }
        ];
        action = [
          {
            service = "cover.close_cover";
            entity_id = "cover.all_blinds";
          }
        ];
      }
      {
        alias = "Close blinds when no-one home";
        id = "close_blinds_no_one_home";
        trigger = [
          {
            platform = "state";
            entity_id = "zone.home";
            to = "0";
            for = {
              minutes = 1;
            };
          }
        ];
        action = [
          {
            service = "cover.close_cover";
            entity_id = "cover.all_blinds";
          }
        ];
      }
      {
        alias = "Open blinds in the morning";
        id = "open_blinds_morning";
        trigger = [
          {
            platform = "time";
            at = "sensor.kat_s_pixel_next_alarm";
          }
          {
            platform = "time";
            at = "sensor.jamie_pixel_8a_next_alarm";
          }
        ];
        condition = [
          {
            condition = "zone";
            entity_id = [
              "person.jamie"
              "person.kat"
            ];
            zone = "zone.home";
          }
        ];
        action = [
          {
            service = "scene.turn_on";
            target = {
              entity_id = "scene.morning_blinds";
            };
          }
        ];
      }
    ];
  };
}
