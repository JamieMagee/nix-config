{
  services.home-assistant.config = {
    automation = [
      {
        alias = "Turn off garage heat overnight";
        id = "garage_heat_overnight";
        trigger = [
          {
            platform = "time";
            at = "22:00:00";
          }
        ];
        action = [
          {
            service = "scene.create";
            data = {
              scene_id = "garage_climate_before";
              snapshot_entities = [ "climate.mysa_89501c_thermostat" ];
            };
          }
          {
            service = "climate.set_hvac_mode";
            target = {
              entity_id = [ "climate.mysa_89501c_thermostat" ];
            };
            data = {
              hvac_mode = "off";
            };
          }
        ];
      }
      {
        alias = "Turn on garage heat in the morning";
        id = "garage_heat_morning";
        trigger = [
          {
            platform = "time";
            at = "06:00:00";
          }
        ];
        condition = [
          {
            condition = "numeric_state";
            entity_id = "zone.home";
            above = 0;
          }
        ];
        action = [
          {
            service = "scene.turn_on";
            target = {
              entity_id = "scene.garage_climate_before";
            };
          }
        ];
      }
    ];
  };
}
