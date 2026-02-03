{ pkgs, ... }:
{
  services.home-assistant = {
    customComponents = with pkgs.home-assistant-custom-components; [
      fellow
    ];
    config = {
      automation = [
        {
          alias = "Notify when coffee brewing is complete";
          description = "Send a notification to with the number of cups brewed";
          trigger = [
            {
              platform = "state";
              entity_id = "binary_sensor.aiden_brewing";
              from = "on";
              to = "off";
            }
          ];
          condition = [ ];
          action = [
            {
              service = "notify.everyone";
              data = {
                title = "Coffee Ready ☕";
                message = "Your coffee is ready! Brewed {{ (states('sensor.aiden_last_brew_volume') | float / 300) | round(0) }} cups.";
              };
            }
          ];
          mode = "single";
        }
      ];
    };
  };
}
