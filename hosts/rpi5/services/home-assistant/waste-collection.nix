{
  services.home-assistant.config = {
    waste_collection_schedule = {
      sources = [
        {
          name = "seattle_gov";
          args = {
            street_address = "!secret address";
          };
        }
      ];
      sensors = [
        {
          name = "Seattle garbage collection";
        }
      ];
    };

    automation = [
      {
        alias = "Notify garbage collection";
        id = "notify_garbage_schedule";
        triggers = [
          {
            trigger = "calendar";
            event = "start";
            offset = "-6:00:00";
            entity_id = "calendar.seattle_public_utilities";
          }
        ];
        actions = [
          {
            action = "notify.everyone";
            data = {
              title = "Garbage collection";
              message = "{{ states(\"sensor.seattle_garbage_collection\") }}";
              data = {
                tag = "garbage_collection";
                notification_icon = "mdi:trash-can";
              };
            };
          }
        ];
      }
    ];
  };
}
