{
  services.home-assistant = {
    extraComponents = [
      "abode"
    ];

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
          entities = [
            "binary_sensor.front_window"
          ];
        }
      ];

      automation = [
        {
          alias = "Notify on alarm change";
          id = "alarm_state_change";
          trigger = [
            {
              platform = "state";
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

          action = [
            {
              service = "notify.everyone";
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
          trigger = [
            {
              platform = "time";
              at = "22:00:00";
            }
          ];
          condition = [
            {
              condition = "state";
              entity_id = [
                "person.jamie"
                "person.kat"
              ];
              state = "home";
            }
          ];
          action = [
            {
              service = "alarm_control_panel.alarm_arm_home";
              entity_id = "alarm_control_panel.abode_alarm";
            }
          ];
        }
        {
          alias = "Arm alarm when no-one home";
          id = "arm_alarm_no_one_home";
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
              service = "alarm_control_panel.alarm_arm_away";
              entity_id = "alarm_control_panel.abode_alarm";
            }
          ];
        }
        {
          alias = "Disarm alarm in the morning";
          id = "disarm_alarm_morning";
          trigger = [
            {
              platform = "time";
              at = "sensor.pixel_5_next_alarm";
            }
            {
              platform = "time";
              at = "sensor.pixel_6_next_alarm";
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
              service = "alarm_control_panel.alarm_disarm";
              entity_id = "alarm_control_panel.abode_alarm";
            }
          ];
        }
      ];
    };
  };
}
