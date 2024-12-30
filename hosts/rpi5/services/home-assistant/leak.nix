{
  services.home-assistant.config = {
    automation = [
      {
        alias = "Notify on leak detected";
        id = "leak_detected";
        triggers = {
          trigger = "state";
          entity_id = [
            "binary_sensor.homelab_zone_bathroom_sink_left_leak_water_leak"
            "binary_sensor.homelab_zone_bathroom_sink_right_leak_water_leak"
            "binary_sensor.homelab_zone_bathroom_toilet_leak_water_leak"
            "binary_sensor.homelab_zone_garage_bathroom_sink_leak_water_leak"
            "binary_sensor.homelab_zone_garage_bathroom_toilet_leak_water_leak"
            "binary_sensor.homelab_zone_kitchen_sink_leak_water_leak"
          ];
          to = "on";
        };
        actions = [
          {
            action = "notify.everyone";
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
