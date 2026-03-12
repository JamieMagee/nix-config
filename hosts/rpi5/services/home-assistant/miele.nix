{
  services.home-assistant = {
    extraComponents = [ "miele" ];

    config = {
      automation = [
        {
          alias = "Notify when tumble dryer finished";
          id = "notify_tumble_dryer_finished";
          triggers = [
            {
              trigger = "state";
              entity_id = "sensor.tumble_dryer";
              to = "program_ended";
            }
          ];
          actions = [
            {
              action = "notify.everyone";
              data = {
                title = "Tumble dryer";
                message = "The tumble dryer is done";
                data = {
                  tag = "tumble_dryer_cycle";
                };
              };
            }
          ];
        }
        {
          alias = "Tumble dryer live notification";
          id = "tumble_dryer_live_notification";
          triggers = [
            {
              trigger = "state";
              entity_id = "sensor.tumble_dryer";
              to = "in_use";
            }
            {
              trigger = "state";
              entity_id = "sensor.tumble_dryer_remaining_time";
            }
          ];
          conditions = [
            {
              condition = "state";
              entity_id = "sensor.tumble_dryer";
              state = "in_use";
            }
          ];
          actions = [
            {
              action = "notify.everyone";
              data = {
                title = "Tumble dryer";
                message = "{% set m = states('sensor.tumble_dryer_remaining_time') | int(0) %}Remaining: {% if m >= 60 %}{{ m // 60 }}h {{ m % 60 }}m{% else %}{{ m }}m{% endif %}";
                data = {
                  tag = "tumble_dryer_cycle";
                  live_update = true;
                  alert_once = true;
                  notification_icon = "mdi:tumble-dryer";
                  critical_text = "{% set m = states('sensor.tumble_dryer_remaining_time') | int(0) %}{% if m >= 60 %}{{ m // 60 }}h {{ m % 60 }}m{% else %}{{ m }}m{% endif %}";
                  chronometer = true;
                  when = "{{ states('sensor.tumble_dryer_remaining_time') | int(0) * 60 }}";
                  when_relative = true;
                };
              };
            }
          ];
        }
        {
          alias = "Notify when washing machine finished";
          id = "notify_washing_machine_finished";
          triggers = [
            {
              trigger = "state";
              entity_id = "sensor.washing_machine";
              to = "program_ended";
            }
          ];
          actions = [
            {
              action = "notify.everyone";
              data = {
                title = "Washing machine";
                message = "The washing machine is done";
                data = {
                  tag = "washing_machine_cycle";
                };
              };
            }
          ];
        }
        {
          alias = "Washing machine live notification";
          id = "washing_machine_live_notification";
          triggers = [
            {
              trigger = "state";
              entity_id = "sensor.washing_machine";
              to = "in_use";
            }
            {
              trigger = "state";
              entity_id = "sensor.washing_machine_remaining_time";
            }
          ];
          conditions = [
            {
              condition = "state";
              entity_id = "sensor.washing_machine";
              state = "in_use";
            }
          ];
          actions = [
            {
              action = "notify.everyone";
              data = {
                title = "Washing machine";
                message = "{% set m = states('sensor.washing_machine_remaining_time') | int(0) %}Remaining: {% if m >= 60 %}{{ m // 60 }}h {{ m % 60 }}m{% else %}{{ m }}m{% endif %}";
                data = {
                  tag = "washing_machine_cycle";
                  live_update = true;
                  alert_once = true;
                  notification_icon = "mdi:washing-machine";
                  critical_text = "{% set m = states('sensor.washing_machine_remaining_time') | int(0) %}{% if m >= 60 %}{{ m // 60 }}h {{ m % 60 }}m{% else %}{{ m }}m{% endif %}";
                  chronometer = true;
                  when = "{{ states('sensor.washing_machine_remaining_time') | int(0) * 60 }}";
                  when_relative = true;
                };
              };
            }
          ];
        }
        {
          alias = "Turn on fan when tumble dryer is running";
          id = "fan_on_tumble_dryer_running";
          triggers = [
            {
              trigger = "state";
              entity_id = "sensor.tumble_dryer";
              to = "in_use";
            }
          ];
          actions = [
            {
              action = "fan.turn_on";
              entity_id = "fan.utility_closet_fan";
            }
          ];
        }
        {
          alias = "Turn off fan when tumble dryer is not running";
          id = "fan_off_tumble_dryer_done";
          triggers = [
            {
              trigger = "state";
              entity_id = "sensor.tumble_dryer";
              to = "program_ended";
            }
          ];
          actions = [
            {
              action = "fan.turn_off";
              entity_id = "fan.utility_closet_fan";
            }
          ];
        }
      ];
    };
  };
}
