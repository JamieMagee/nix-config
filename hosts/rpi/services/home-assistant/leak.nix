{
  services.home-assistant.config = {
    automation = [
      {
        alias = "Notify on leak detected";
        id = "leak_detected";
        trigger = {
          platform = "state";
          entity_id = [
            "binary_sensor.bathroom_sink_left_water_leak"
            "binary_sensor.bathroom_sink_right_water_leak"
            "binary_sensor.bathroom_toilet_water_leak"
            "binary_sensor.garage_bathroom_sink_water_leak"
            "binary_sensor.garage_bathroom_toilet_water_leak"
            "binary_sensor.kitchen_sink_water_leak"
          ];
          to = "on";
        };
        action = [
          {
            service = "notify.everyone";
            data = {
              title = "Leak detected!";
              message = "A leak has been detected in the {{ trigger.to_state.attributes.friendly_name | lower }}";
            };
          }
        ];
      }
    ];
  };
}
