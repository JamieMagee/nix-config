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
              "weather.forecast_home"
            ];
            attribute = "uv_index";
            above = 5;
          }
        ];
        actions = [
          {
            service = "notify.everyone";
            data = {
              title = "High UV index";
              message = "The UV index is {{ trigger.to_state.attributes.uv_index }}";
            };
          }
        ];
      }
    ];
  };
}
