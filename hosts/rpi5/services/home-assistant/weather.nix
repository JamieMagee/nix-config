{
  services.home-assistant.config = {
    automation = [
      {
        alias = "UV Index Notification";
        id = "uv_index";
        description = "Notify when UV index is high";
        triggers = [
          {
            trigger = "numeric_state";
            entity_id = [
              "sensor.pirateweather_uv_index"
            ];
            above = 5;
          }
        ];
        actions = [
          {
            action = "notify.everyone";
            data = {
              title = "High UV index";
              message = "The UV index is {{ trigger.to_state.state }}";
              data = {
                tag = "uv_index";
                notification_icon = "mdi:weather-sunny-alert";
              };
            };
          }
        ];
      }
    ];
  };
}
