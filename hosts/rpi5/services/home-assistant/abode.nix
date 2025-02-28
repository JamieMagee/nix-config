{
  services.home-assistant = {
    extraComponents = [ "abode" ];

    config = {
      binary_sensor = [
        {
          platform = "group";
          name = "Doors";
          entities = [
            "binary_sensor.front_door"
            "binary_sensor.balcony_door"
            "binary_sensor.garage_door"
          ];
        }
        {
          platform = "group";
          name = "Windows";
          entities = [ "binary_sensor.front_window" ];
        }
      ];

      automation = [
        {
          alias = "Notify on alarm change";
          id = "alarm_state_change";
          triggers = [
            {
              trigger = "state";
              entity_id = "alarm_control_panel.abode_alarm";
              not_from = [
                "unknown"
                "unavailable"
              ];
              to = null;
            }
          ];
          condition = {
            not = [
              {
                condition = "state";
                entity_id = "alarm_control_panel.abode_alarm";
                state = "unavailable";
              }
            ];
          };

          actions = [
            {
              action = "notify.everyone";
              data = {
                title = "Alarm";
                message = ''
                  {%- if is_state("alarm_control_panel.abode_alarm", "armed_away") -%}
                    No-one is home. The alarm is armed
                  {%- elif is_state("alarm_control_panel.abode_alarm", "disarmed") -%}
                    Alarm disabled
                  {%- elif is_state("alarm_control_panel.abode_alarm", "armed_home") -%}
                    The alarm is armed home.
                  {%- endif %}
                '';
              };
            }
          ];
        }
        {
          alias = "Arm alarm at night";
          id = "arm_alarm_night";
          triggers = [
            {
              trigger = "time";
              at = "22:00:00";
            }
          ];
          conditions = {
            condition = "or";
            conditions = [
              {
                condition = "state";
                entity_id = [
                  "person.jamie"
                ];
                state = "home";
              }
              {
                condition = "state";
                entity_id = [
                  "person.kat"
                ];
                state = "home";
              }
            ];
          };
          actions = [
            {
              action = "alarm_control_panel.alarm_arm_home";
              entity_id = "alarm_control_panel.abode_alarm";
            }
          ];
        }
        {
          alias = "Notify when alarm disarmed overnight";
          id = "alarm_disarmed_overnight";
          triggers = [
            {
              trigger = "state";
              entity_id = "alarm_control_panel.abode_alarm";
              from = "armed_away";
              to = "disarmed";
            }
          ];
          conditions = [
            {
              condition = "time";
              after = "22:00:00";
              before = "07:00:00";
            }
          ];
          actions = [
            {
              action = "notify.everyone";
              data = {
                title = "Alarm";
                message = "Don't forget to re-arm the alarm!";
              };
            }
          ];
        }
        {
          alias = "Arm alarm when no-one home";
          id = "arm_alarm_no_one_home";
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
              action = "alarm_control_panel.alarm_arm_away";
              entity_id = "alarm_control_panel.abode_alarm";
            }
          ];
        }
        {
          alias = "Disarm alarm in the morning";
          id = "disarm_alarm_morning";
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
              action = "alarm_control_panel.alarm_disarm";
              entity_id = "alarm_control_panel.abode_alarm";
            }
          ];
        }
      ];
    };
  };
}
