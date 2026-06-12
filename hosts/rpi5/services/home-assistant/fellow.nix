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
          id = "notify_coffee_brewing_complete";
          description = "Send a notification when a brew finishes, i.e. the brewing binary sensor transitions from on to off";
          triggers = [
            {
              trigger = "state";
              entity_id = "binary_sensor.aiden_brewing";
              from = "on";
              to = "off";
            }
          ];
          actions = [
            {
              action = "notify.everyone";
              data = {
                title = "Coffee Ready ☕";
                message = "Your coffee is ready! Brewed {{ (states('sensor.aiden_last_brew_volume') | float / 300) | round(0) }} cups.";
                data = {
                  tag = "coffee_ready";
                  notification_icon = "mdi:coffee";
                };
              };
            }
          ];
          mode = "single";
        }
      ];
    };
  };
}
