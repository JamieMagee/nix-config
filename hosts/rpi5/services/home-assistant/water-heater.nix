{
  services.home-assistant = {
    extraComponents = [
      "econet"
    ];

    config = {
      automation = [
        {
          alias = "Water heater eco mode during off-peak";
          id = "water_heater_off_peak_eco";
          triggers = [
            {
              trigger = "state";
              entity_id = "sensor.scl_tou_period";
              to = "Off-Peak";
            }
          ];
          actions = [
            {
              action = "water_heater.set_operation_mode";
              target = {
                entity_id = "water_heater.heat_pump_water_heater";
              };
              data = {
                operation_mode = "eco";
              };
            }
          ];
        }
        {
          alias = "Water heater off outside off-peak";
          id = "water_heater_off_peak_end";
          triggers = [
            {
              trigger = "state";
              entity_id = "sensor.scl_tou_period";
              from = "Off-Peak";
            }
          ];
          actions = [
            {
              action = "water_heater.turn_off";
              target = {
                entity_id = "water_heater.heat_pump_water_heater";
              };
            }
          ];
        }
      ];
    };
  };
}
