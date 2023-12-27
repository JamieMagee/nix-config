{pkgs, ...}: {
  services.home-assistant = {
    customComponents = with pkgs.home-assistant-custom-components; [
      miele
    ];

    config = {
      automation = [
        {
          alias = "Notify when tumble dryer finished";
          trigger = [
            {
              platform = "state";
              entity_id = "sensor.tumble_dryer_status";
              to = "program_ended";
            }
          ];
          action = [
            {
              service = "notify.everyone";
              data = {
                title = "Tumblr dryer";
                message = "The tumble dryer is done";
              };
            }
          ];
        }
        {
          alias = "Notify when washing machine finished";
          trigger = [
            {
              platform = "state";
              entity_id = "sensor.washing_machine_status";
              to = "program_ended";
            }
          ];
          action = [
            {
              service = "notify.everyone";
              data = {
                title = "Washing machine";
                message = "The washing machine is done";
              };
            }
          ];
        }
      ];
    };
  };
}
