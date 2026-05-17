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
          alias = "[Vacation] Open blinds and turn on lights in the morning";
          id = "open_blinds_turn_on_lights_morning_vacation";
          triggers = [
            {
              trigger = "sun";
              event = "sunrise";
              offset = "-00:30:00";
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
              delay = {
                minutes = "{{ range(0, 30) | random }}";
              };
            }
            {
              action = "scene.turn_on";
              target = {
                entity_id = [
                  "scene.upstairs_blinds_daytime"
                ];
              };
            }
            {
              action = "light.turn_on";
              target = {
                entity_id = [
                  "light.indoor_lights"
                ];
              };
            }
            {
              delay = {
                minutes = "{{ range(15, 40) | random }}";
              };
            }
            {
              action = "scene.turn_on";
              target = {
                entity_id = [
                  "scene.downstairs_blinds_daytime"
                ];
              };
            }
          ];
        }
        {
          alias = "[Vacation] Turn off morning lights after sunrise";
          id = "turn_off_morning_lights_vacation";
          triggers = [
            {
              trigger = "sun";
              event = "sunrise";
              offset = "+00:45:00";
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
              delay = {
                minutes = "{{ range(0, 20) | random }}";
              };
            }
            {
              action = "light.turn_off";
              target = {
                entity_id = [
                  "light.indoor_lights"
                ];
              };
            }
          ];
        }
        {
          alias = "[Vacation] Turn on evening lights at sunset";
          id = "turn_on_evening_lights_vacation";
          triggers = [
            {
              trigger = "sun";
              event = "sunset";
              offset = "-00:15:00";
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
              delay = {
                minutes = "{{ range(0, 25) | random }}";
              };
            }
            {
              action = "light.turn_on";
              target = {
                entity_id = [
                  "light.indoor_lights"
                ];
              };
            }
          ];
        }
        {
          alias = "[Vacation] Turn off lights and TV at night";
          id = "turn_off_lights_and_tv_night_vacation";
          triggers = [
            {
              trigger = "time";
              at = "22:45:00";
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
              delay = {
                minutes = "{{ range(0, 45) | random }}";
              };
            }
            {
              action = "light.turn_off";
              target = {
                entity_id = [
                  "light.indoor_lights"
                ];
              };
            }
            {
              action = "media_player.turn_off";
              target = {
                entity_id = [
                  "media_player.shield_2"
                ];
              };
            }
          ];
        }
        {
          alias = "[Vacation] Turn on TV in the evening";
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
            # {
            #   delay = {
            #     minutes = "{{ range(0, 30) | random }}";
            #   };
            # }
            {
              action = "media_player.turn_on";
              target = {
                entity_id = [
                  "media_player.shield_2"
                ];
              };
            }
            {
              wait_template = "{{ states('media_player.shield_2') not in ['off', 'unavailable', 'unknown'] }}";
              timeout = "00:01:00";
              continue_on_timeout = false;
            }
            {
              wait_template = "{{ states('media_player.shield') in ['idle', 'playing', 'paused'] }}";
              timeout = "00:01:30";
              continue_on_timeout = true;
            }
            {
              action = "media_player.volume_set";
              target = {
                entity_id = "media_player.living_room";
              };
              data = {
                volume_level = 0.2;
              };
            }
            {
              variables = {
                video_id = ''
                  {{ ['zomZywCAPTA', 'jfKfPfyJRdk'] | random }}'';
              };
            }
            {
              repeat = {
                sequence = [
                  {
                    action = "media_player.play_media";
                    target = {
                      entity_id = "media_player.shield";
                    };
                    data = {
                      media_content_type = "cast";
                      media_content_id = ''{"app_name":"youtube","media_id":"{{ video_id }}"}'';
                    };
                  }
                  {
                    delay = {
                      seconds = 15;
                    };
                  }
                ];
                until = [
                  {
                    condition = "or";
                    conditions = [
                      {
                        condition = "template";
                        value_template = "{{ states('media_player.shield') in ['playing', 'paused'] }}";
                      }
                      {
                        condition = "template";
                        value_template = "{{ repeat.index >= 3 }}";
                      }
                    ];
                  }
                ];
              };
            }
          ];
        }
        {
          alias = "[Vacation] Restore normal state when vacation mode turns off";
          id = "vacation_mode_off_restore";
          triggers = [
            {
              trigger = "state";
              entity_id = "input_boolean.vacation_mode";
              from = "on";
              to = "off";
            }
          ];
          actions = [
            {
              action = "media_player.turn_off";
              target = {
                entity_id = [
                  "media_player.shield_2"
                ];
              };
            }
            {
              action = "light.turn_off";
              target = {
                entity_id = [
                  "light.indoor_lights"
                ];
              };
            }
          ];
        }
      ];
    };
  };
}
