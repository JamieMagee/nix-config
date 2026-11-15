{ pkgs, ... }:
# After deploying:
# - Get OpenPlantbook credentials from /apikey/show/ at https://open.plantbook.io.
# - Add OpenPlantbook in Home Assistant and enable "Automatically Download Images".
# - Pair sensors in Zigbee2MQTT and set stable `friendly_name` values in mqtt.nix.
# - Add each plant in Plant Monitor, using the moisture template sensor below.
# - Add a `custom:flower-card` in lovelace.nix and run `nixos-rebuild switch`.
{
  services.home-assistant = {
    customComponents = with pkgs.home-assistant-custom-components; [
      openplantbook
      plant
    ];

    config = {
      # Tuya reports soil moisture as humidity, which Plant Monitor filters out.
      # Republish it with `device_class: moisture` so it appears in the selector.
      template = [
        {
          sensor = [
            {
              name = "Kitchen Calathea Moisture";
              unique_id = "kitchen_calathea_moisture";
              unit_of_measurement = "%";
              device_class = "moisture";
              state_class = "measurement";
              state = ''
                {{ states('sensor.kitchen_calathea_soil_moisture') }}
              '';
              availability = ''
                {{ states('sensor.kitchen_calathea_soil_moisture')
                   not in ['unknown', 'unavailable'] }}
              '';
            }
          ];
        }
      ];

      automation = [
        {
          alias = "Notify on plant problem";
          id = "notify_plant_problem";
          description = ''
            Daily 10:00 check for any plant entity in the 'problem' state.
            Plant Monitor's built-in 5% hysteresis combined with the
            once-per-day cadence prevents notification flapping. To switch
            to real-time alerts, swap the time trigger for a per-entity
            state trigger with `to = "problem"`.
          '';
          triggers = [
            {
              trigger = "time";
              at = "10:00:00";
            }
          ];
          conditions = [
            {
              condition = "template";
              value_template = ''
                {{ states.plant
                   | selectattr('state', 'eq', 'problem')
                   | list | count > 0 }}
              '';
            }
          ];
          actions = [
            {
              action = "notify.everyone";
              data = {
                title = "Plant problem 🌱";
                # Plant Monitor stores each measurement's state in
                # `<meter>_status` attributes, with values like 'Low' / 'OK' / 'High'.
                message = ''
                  {% for p in states.plant if p.state == 'problem' %}
                  • {{ p.name }}:
                  {%- set issues = namespace(items=[]) -%}
                  {%- for k, v in p.attributes.items() -%}
                    {%- if k.endswith('_status') and v not in ['OK', None] -%}
                      {%- set issues.items = issues.items + [k[:-7] ~ ' ' ~ v|lower] -%}
                    {%- endif -%}
                  {%- endfor %} {{ issues.items | join(', ') if issues.items else 'see plant details' }}
                  {% endfor %}
                '';
                data = {
                  tag = "plant_problem";
                  notification_icon = "mdi:sprout";
                };
              };
            }
          ];
          mode = "single";
        }
        {
          alias = "Clear plant problem notification";
          id = "clear_plant_problem_notification";
          description = ''
            Dismiss the `plant_problem` notification once every plant has
            recovered to a non-problem state. Mirrors the bike-charging
            clear pattern in battery.nix.
          '';
          triggers = [
            {
              trigger = "template";
              value_template = ''
                {{ states.plant
                   | selectattr('state', 'eq', 'problem')
                   | list | count == 0 }}
              '';
              for = {
                minutes = 5;
              };
            }
          ];
          actions = [
            {
              action = "notify.everyone";
              data = {
                message = "clear_notification";
                data = {
                  tag = "plant_problem";
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
