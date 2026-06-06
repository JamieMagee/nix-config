{ pkgs, ... }:
# Plant monitoring (Olen ecosystem + Tuya TS0601_soil Zigbee sensors).
#
# Post-deploy manual steps (only needed the first time, or per new plant):
#   1. Register at https://open.plantbook.io and copy
#      client_id / client_secret from /apikey/show/.
#   2. HA → Settings → Devices & Services → Add Integration →
#      "OpenPlantbook" → enter creds. Under Configure, enable
#      "Automatically Download Images".
#   3. Pair Zigbee soil sensor(s) at http://192.168.1.3:8080
#      (Zigbee2MQTT frontend), then give each one a stable `friendly_name`
#      in mqtt.nix (e.g. `kitchen/calathea`) so its entity IDs are stable.
#      Recommended hardware: Tuya TS0601_soil family — exposes soil_moisture,
#      temperature, battery, battery_state.
#   4. HA → Settings → Devices & Services → Add Integration →
#      "Plant Monitor" → 4-step flow per plant (browse OpenPlantbook →
#      select species → assign sensors → confirm thresholds). Assign the
#      moisture role to the `device_class: moisture` template sensor created
#      below (e.g. `sensor.kitchen_calathea_moisture`), NOT the raw
#      `sensor.<name>_soil_moisture` entity (see the gotcha below).
#   5. Edit lovelace.nix `Plants` view and add one `custom:flower-card`
#      block per plant, then `nixos-rebuild switch`.
#
# `device_class` gotcha — TS0601_soil reports soil moisture under
# `device_class: humidity`, which the Plant Monitor config-flow moisture
# dropdown filters out. This file works around it with the template sensor
# below, which re-publishes the value as `device_class: moisture`. (Other
# options, if you prefer: a `customize.yaml` override, or the relaxed
# `plant.replace_sensor` service call.)
{
  services.home-assistant = {
    customComponents = with pkgs.home-assistant-custom-components; [
      openplantbook
      plant
    ];

    config = {
      # Re-publish the Tuya soil sensor's `soil_moisture` reading with
      # `device_class: moisture` so the Plant Monitor config-flow moisture
      # dropdown accepts it. TS0601_soil publishes soil moisture under
      # `device_class: humidity`, which that dropdown filters out.
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
            # Optional: a TS0601_soil variant that reports only a `battery_state`
            # enum (low/medium/high) instead of a numeric `battery` % can be
            # mapped to a numeric % by copying this entry, renaming the IDs and
            # source entity, then uncommenting. Olen's TIPS.md recommends
            # low=19 / medium=39 / high=70 as representative midpoints. The
            # TS0601_soil_3 used for the Calathea reports a numeric `battery`
            # already, so it doesn't need this.
            #
            # {
            #   name = "Living Room Plant Battery";
            #   unique_id = "living_room_plant_battery_pct";
            #   unit_of_measurement = "%";
            #   device_class = "battery";
            #   state_class = "measurement";
            #   state = ''
            #     {% set raw = states('sensor.living_room_plant_battery_state') %}
            #     {% if raw == 'low' %}19
            #     {% elif raw == 'medium' %}39
            #     {% elif raw == 'high' %}70
            #     {% endif %}
            #   '';
            #   availability = ''
            #     {{ states('sensor.living_room_plant_battery_state')
            #        in ['low', 'medium', 'high'] }}
            #   '';
            # }
          ];
        }
      ];

      # Note: Plant Monitor's VPD calculation has a bug under imperial units
      # (upstream issue #440). This host doesn't set `homeassistant.unit_system`
      # explicitly — leave it on metric (HA default for new installs in
      # Europe) or skip the `vpd` bar in flower-card configs if unsure.

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
                # Iterate problematic plants and list each plant's non-OK
                # status attributes. Plant Monitor exposes per-meter
                # state under attributes named `<meter>_status` with
                # values like 'Low' / 'OK' / 'High'.
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
