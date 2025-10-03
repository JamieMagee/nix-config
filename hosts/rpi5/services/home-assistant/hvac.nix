{
  services.home-assistant.config = {
    automation = [
      {
        alias = "Turn off HVAC when no one is home";
        triggers = [
          {
            trigger = "state";
            entity_id = "zone.home";
            to = "0";
            for = {
              minutes = 1;
            };
          }
        ];
        actions = [
          {
            action = "scene.create";
            data = {
              scene_id = "hvac_off_before";
              snapshot_entities = [
                "climate.esphome_web_6c4990_bedroom_mini_split"
                "climate.esphome_web_6ab408_office_mini_split"
                "climate.esphome_web_6c37b0_downstairs_mini_split"
                "climate.mysa_89501c_thermostat"
                "climate.mysa_2bbd00_thermostat"
              ];
            };
          }
          {
            action = "climate.set_hvac_mode";
            target = {
              entity_id = [
                "climate.esphome_web_6c4990_bedroom_mini_split"
                "climate.esphome_web_6ab408_office_mini_split"
                "climate.esphome_web_6c37b0_downstairs_mini_split"
                "climate.mysa_89501c_thermostat"
                "climate.mysa_2bbd00_thermostat"
              ];
            };
            data = {
              hvac_mode = "off";
            };
          }
        ];
      }
      {
        alias = "Turn on HVAC when someone is home";
        triggers = [
          {
            trigger = "state";
            entity_id = "zone.home";
            from = "0";
            to = "1";
          }
        ];
        actions = [
          {
            action = "scene.turn_on";
            target = {
              entity_id = "scene.hvac_off_before";
            };
          }
        ];
      }
      {
        alias = "Turn off garage heat overnight";
        id = "garage_heat_overnight";
        triggers = [
          {
            trigger = "time";
            at = "22:00:00";
          }
        ];
        actions = [
          {
            action = "scene.create";
            data = {
              scene_id = "garage_climate_before";
              snapshot_entities = [
                "climate.mysa_89501c_thermostat"
                "climate.mysa_2bbd00_thermostat"
              ];
            };
          }
          {
            action = "climate.set_hvac_mode";
            target = {
              entity_id = [
                "climate.mysa_89501c_thermostat"
                "climate.mysa_2bbd00_thermostat"
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
        triggers = [
          {
            trigger = "time";
            at = "06:00:00";
          }
        ];
        conditions = [
          {
            condition = "numeric_state";
            entity_id = "zone.home";
            above = 0;
          }
        ];
        actions = [
          {
            action = "scene.turn_on";
            target = {
              entity_id = "scene.garage_climate_before";
            };
          }
        ];
      }
      {
        alias = "Turn on bathroom fan when humidity is high";
        id = "bathroom_fan_humidity";
        triggers = [
          {
            trigger = "numeric_state";
            entity_id = "sensor.0x00158d008b7ca529_humidity";
            above = 60;
          }
        ];
        actions = [
          {
            action = "fan.turn_on";
            target = {
              entity_id = "fan.bathroom_fan";
            };
          }
        ];
      }
      {
        alias = "Turn off bathroom fan when humidity is low";
        id = "bathroom_fan_humidity_off";
        triggers = [
          {
            trigger = "numeric_state";
            entity_id = "sensor.0x00158d008b7ca529_humidity";
            below = 55;
          }
        ];
        actions = [
          {
            action = "fan.turn_off";
            target = {
              entity_id = "fan.bathroom_fan";
            };
          }
        ];
      }
      {
        alias = "Mini Split - Turn Off At Night";
        id = "mini_split_night_off";
        triggers = [
          {
            trigger = "time";
            at = "22:00:00";
          }
        ];
        conditions = [
          {
            condition = "numeric_state";
            entity_id = "zone.home";
            above = 0;
          }
        ];
        actions = [
          {
            action = "climate.set_hvac_mode";
            target = {
              entity_id = [
                "climate.esphome_web_6ab408_office_mini_split"
                "climate.esphome_web_6c37b0_downstairs_mini_split"
              ];
            };
            data = {
              hvac_mode = "off";
            };
          }
          {
            action = "climate.set_hvac_mode";
            target = {
              entity_id = "climate.esphome_web_6c4990_bedroom_mini_split";
            };
            data = {
              hvac_mode = "cool";
            };
          }
          {
            action = "climate.set_temperature";
            target = {
              entity_id = "climate.esphome_web_6c4990_bedroom_mini_split";
            };
            data = {
              temperature = 20;
            };
          }
          {
            action = "climate.set_fan_mode";
            target = {
              entity_id = "climate.esphome_web_6c4990_bedroom_mini_split";
            };
            data = {
              fan_mode = "low";
            };
          }
        ];
      }
    ];
  };
}
