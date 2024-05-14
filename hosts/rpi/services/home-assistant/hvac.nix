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
      {
        alias = "Turn off mini split overnight";
        id = "mini_split_overnight";
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
              scene_id = "mini_split_climate_before";
              snapshot_entities = [ "climate.esphome_web_e35511_office_mini_split" ];
            };
          }
          {
            service = "climate.set_hvac_mode";
            target = {
              entity_id = [ "climate.esphome_web_e35511_office_mini_split" ];
            };
            data = {
              hvac_mode = "off";
            };
          }
        ];
      }
      {
        alias = "Turn on mini split in the morning";
        id = "mini_split_morning";
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
              entity_id = "scene.mini_split_climate_before";
            };
          }
        ];
      }
    ];

    climate = [
      {
        platform = "group";
        name = "Mini splits";
        entities = [
          "climate.esphome_web_6c37b0_downstairs_mini_split"
          "climate.esphome_web_e35511_office_mini_split"
        ];
      }
    ];
  };
}
