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
              snapshot_entities = [
                "climate.mysa_89501c_thermostat"
              ];
            };
          }
          {
            service = "climate.set_hvac_mode";
            target = {
              entity_id = [
                "climate.mysa_89501c_thermostat"
              ];
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
      {
        alias = "Turn off heat pump overnight";
        id = "heat_pump_overnight";
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
              scene_id = "heat_pump_climate_before";
              snapshot_entities = [
                "climate.esphome_web_e35511_office_ac"
              ];
            };
          }
          {
            service = "climate.set_hvac_mode";
            target = {
              entity_id = [
                "climate.esphome_web_e35511_office_ac"
              ];
            };
            data = {
              hvac_mode = "off";
            };
          }
        ];
      }
      {
        alias = "Turn on heat pump in the morning";
        id = "heat_pump_morning";
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
              entity_id = "scene.heat_pump_climate_before";
            };
          }
        ];
      }
    ];
  };
}
