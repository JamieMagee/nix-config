{
  services.home-assistant = {
    extraComponents = [
      "ffmpeg"
      "media_extractor"
    ];
    config = {
      input_boolean = {
        vacation_mode = {
          name = "Vacation Mode";
        };
      };
      automation = [
        {
          alias = "Open blinds and turn on lights in the morning";
          id = "open_blinds_turn_on_lights_morning_vacation";
          triggers = [
            {
              trigger = "sun";
              event = "sunrise";
            }
          ];
          conditions = [
            {
              condition = "state";
              entity_id = "input_boolean.vacation_mode";
              state = "on";
            }
          ];
          actions = [
            {
              action = "scene.turn_on";
              target = {
                entity_id = [
                  "scene.upstairs_blinds_daytime"
                  "scene.downstairs_blinds_daytime"
                ];
              };
            }
            {
              action = "light.turn_on";
              target = {
                entity_id = [
                  "light.homelab_group_indoor_lights"
                ];
              };
            }
          ];
        }
        {
          alias = "Turn off lights at night";
          id = "turn_off_lights_night_vacation";
          triggers = [
            {
              trigger = "time";
              at = "23:00:00";
            }
          ];
          conditions = [
            {
              condition = "state";
              entity_id = "input_boolean.vacation_mode";
              state = "on";
            }
          ];
          actions = [
            {
              action = "light.turn_off";
              target = {
                entity_id = [
                  "light.homelab_group_indoor_lights"
                ];
              };
            }
          ];
        }
        {
          alias = "Turn on TV in the evening";
          id = "turn_on_tv_evening_vacation";
          triggers = [
            {
              trigger = "sun";
              event = "sunset";
            }
          ];
          conditions = [
            {
              condition = "state";
              entity_id = "input_boolean.vacation_mode";
              state = "on";
            }
          ];
          actions = [
            {
              action = "media_player.turn_on";
              target = {
                entity_id = [
                  "media_player.shield"
                ];
              };
            }
            {
              wait_template = "{{ states('media_player.shield') != off  }}";
            }
            {
              action = "media_extractor.play_media";
              target = {
                entity_id = "media_player.shield";
              };
              data = {
                media_content_id = "https://www.youtube.com/watch?v=zomZywCAPTA";
                media_content_type = "VIDEO";
              };
            }
            {
              action = "media_player.volume_mute";
              target = {
                entity_id = "media_player.shield";
              };
              data = {
                is_volume_muted = true;
              };
            }
          ];
        }
        {
          alias = "Turn off TV at night";
          id = "turn_off_tv_night_vacation";
          triggers = [
            {
              trigger = "time";
              at = "23:00:00";
            }
          ];
          conditions = [
            {
              condition = "state";
              entity_id = "input_boolean.vacation_mode";
              state = "on";
            }
          ];
          actions = [
            {
              action = "media_player.turn_off";
              target = {
                entity_id = [
                  "media_player.shield"
                ];
              };
            }
          ];
        }
      ];
    };
  };
}
