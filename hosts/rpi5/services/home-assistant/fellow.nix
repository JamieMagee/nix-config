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
          description = "Send a notification when the brew end time changes, indicating a brew just finished";
          trigger = [
            {
              platform = "state";
              entity_id = "sensor.last_brew_end_time";
            }
          ];
          condition = [
            {
              condition = "template";
              value_template = "{{ trigger.from_state.state not in ['unknown', 'unavailable'] and trigger.to_state.state not in ['unknown', 'unavailable'] and trigger.from_state.state != trigger.to_state.state }}";
            }
          ];
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
