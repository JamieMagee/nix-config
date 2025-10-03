{ lib, ... }:
{
  services.home-assistant.config = {
    cover = [
      {
        platform = "group";
        name = "All blinds";
        entities = [
          "cover.living_room_big_shade"
          "cover.living_room_small_shade"
          "cover.kitchen_shade"
          "cover.bedroom_big_shade"
          "cover.bedroom_small_shade"
          "cover.office_shade"
          "cover.bathroom_big_shade"
          "cover.bathroom_small_shade"
          "cover.upstairs_hallway_shade"
        ];
      }
      {
        platform = "group";
        name = "Downstairs blinds";
        entities = [
          "cover.living_room_big_shade"
          "cover.living_room_small_shade"
          "cover.kitchen_shade"
        ];
      }
      {
        platform = "group";
        name = "Upstairs blinds";
        entities = [
          "cover.bedroom_big_shade"
          "cover.bedroom_small_shade"
          "cover.office_shade"
          "cover.bathroom_big_shade"
          "cover.bathroom_small_shade"
          "cover.upstairs_hallway_shade"
        ];
      }
      {
        platform = "group";
        name = "Bedroom blinds";
        entities = [
          "cover.bedroom_big_shade"
          "cover.bedroom_small_shade"
        ];
      }
      {
        platform = "group";
        name = "Bathroom blinds";
        entities = [
          "cover.bathroom_big_shade"
          "cover.bathroom_small_shade"
        ];
      }
    ];

    scene = [
      {
        name = "Downstairs blinds daytime";
        icon = "mdi:blinds";
        entities = {
          "cover.living_room_big_shade" = {
            current_position = 2;
            state = "open";
          };
          "cover.living_room_small_shade" = {
            current_position = 2;
            state = "open";
          };
          "cover.kitchen_shade" = {
            current_position = 100;
            state = "open";
          };
        };
      }
      {
        name = "Upstairs blinds daytime";
        icon = "mdi:blinds";
        entities =
          lib.genAttrs
            [
              "cover.office_shade"
              "cover.bathroom_big_shade"
              "cover.bathroom_small_shade"
              "cover.upstairs_hallway_shade"
            ]
            (_: {
              current_position = 100;
              state = "open";
            });
      }
      {
        name = "Morning blinds";
        icon = "mdi:blinds";
        entities =
          lib.genAttrs
            [
              "cover.bathroom_big_shade"
              "cover.bathroom_small_shade"
              "cover.upstairs_hallway_shade"
            ]
            (_: {
              current_position = 100;
              state = "open";
            });
      }
    ];

    automation = [
      {
        alias = "Close blinds at sunset";
        id = "close_blinds_sunset";
        triggers = [
          {
            trigger = "sun";
            event = "sunset";
          }
          {
            trigger = "time";
            at = "18:00:00";
          }
        ];
        actions = [
          {
            action = "cover.close_cover";
            entity_id = "cover.all_blinds";
          }
        ];
      }
      {
        alias = "Close blinds when no-one home";
        id = "close_blinds_no_one_home";
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
            action = "cover.close_cover";
            entity_id = "cover.all_blinds";
          }
        ];
      }
      {
        alias = "Open blinds in the morning";
        id = "open_blinds_morning";
        triggers = [
          {
            trigger = "time";
            at = "sensor.kat_s_pixel_next_alarm";
          }
          {
            trigger = "time";
            at = "sensor.jamie_pixel_8a_next_alarm";
          }
        ];
        conditions = [
          {
            condition = "zone";
            entity_id = [
              "person.jamie"
              "person.kat"
            ];
            zone = "zone.home";
          }
        ];
        actions = [
          {
            action = "scene.turn_on";
            target = {
              entity_id = "scene.morning_blinds";
            };
          }
        ];
      }
    ];
  };
}
