{
  services.home-assistant = {
    extraComponents = [ "miele" ];

    config = {
      automation = [
        {
          alias = "Notify when tumble dryer finished";
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
              };
            }
          ];
        }
        {
          alias = "Notify when washing machine finished";
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
              };
            }
          ];
        }
        {
          alias = "Turn on fan when tumble dryer is running";
          triggers = [
            {
              trigger = "state";
              entity_id = "sensor.tumble_dryer";
              to = "running";
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
