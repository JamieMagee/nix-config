{
  services.home-assistant.config = {
    template = [
      {
        sensor = [
          {
            name = "Low Battery Devices";
            unique_id = "low_battery_devices";
            icon = "mdi:battery-alert";
            state = ''
              {% set threshold = 20 %}
              {% set ns = namespace(count=0) %}
              {% for state in states.sensor %}
                {% if state.attributes.device_class is defined
                   and state.attributes.device_class == 'battery'
                   and state.state not in ['unknown', 'unavailable']
                   and state.state | float(100) < threshold %}
                  {% set ns.count = ns.count + 1 %}
                {% endif %}
              {% endfor %}
              {{ ns.count }}
            '';
            attributes = {
              devices = ''
                {% set threshold = 20 %}
                {% set ns = namespace(devices=[]) %}
                {% for state in states.sensor %}
                  {% if state.attributes.device_class is defined
                     and state.attributes.device_class == 'battery'
                     and state.state not in ['unknown', 'unavailable']
                     and state.state | float(100) < threshold %}
                    {% set ns.devices = ns.devices + [state.name ~ ' (' ~ state.state ~ '%)'] %}
                  {% endif %}
                {% endfor %}
                {{ ns.devices }}
              '';
            };
          }
        ];
      }
    ];

    automation = [
      {
        alias = "Notify on low battery";
        id = "notify_low_battery";
        triggers = [
          {
            trigger = "time";
            at = "10:00:00";
          }
        ];
        conditions = [
          {
            condition = "numeric_state";
            entity_id = "sensor.low_battery_devices";
            above = 0;
          }
        ];
        actions = [
          {
            action = "notify.everyone";
            data = {
              title = "Low battery";
              message = "{{ state_attr('sensor.low_battery_devices', 'devices') }}";
              data = {
                tag = "low_battery";
                notification_icon = "mdi:battery-alert";
              };
            };
          }
        ];
      }
      {
        alias = "Notify on bike battery full";
        id = "notify_bike_battery_full";
        triggers = [
          {
            trigger = "template";
            value_template = ''
              {% for state in states.sensor %}
                {% if state.attributes.device_class is defined
                   and state.attributes.device_class == 'battery'
                   and state.entity_id.startswith('sensor.specialized_turbo')
                   and state.state not in ['unknown', 'unavailable']
                   and state.state | float(0) >= 99 %}
                  true
                {% endif %}
              {% endfor %}
            '';
          }
        ];
        conditions = [
          {
            condition = "template";
            value_template = ''
              {{ trigger.entity_id.startswith('sensor.specialized_turbo')
                 and trigger.from_state.state not in ['unknown', 'unavailable'] }}
            '';
          }
        ];
        actions = [
          {
            action = "notify.everyone";
            data = {
              title = "Bike battery full";
              message = ''
                {% for state in states.sensor %}
                  {% if state.attributes.device_class is defined
                     and state.attributes.device_class == 'battery'
                     and state.entity_id.startswith('sensor.specialized_turbo')
                     and state.state not in ['unknown', 'unavailable']
                     and state.state | float(0) >= 99 %}
                    {{ state.name }} is fully charged.
                  {% endif %}
                {% endfor %}
              '';
              data = {
                tag = "bike_charging";
                notification_icon = "mdi:battery-check";
              };
            };
          }
        ];
      }
      {
        alias = "Bike battery charging live notification";
        id = "bike_battery_charging_live";
        triggers = [
          {
            trigger = "state";
            entity_id = [
              "sensor.specialized_turbo_jamie_battery"
              "sensor.specialized_turbo_kat_battery"
            ];
          }
        ];
        conditions = [
          {
            condition = "template";
            value_template = ''
              {{ trigger.to_state.state not in ['unknown', 'unavailable']
                 and trigger.to_state.state | float(0) >= 1
                 and trigger.to_state.state | float(0) < 99 }}
            '';
          }
        ];
        actions = [
          {
            action = "notify.everyone";
            data = {
              title = "Bike charging";
              message = ''
                {% for state in states.sensor %}
                  {% if state.attributes.device_class is defined
                     and state.attributes.device_class == 'battery'
                     and state.entity_id.startswith('sensor.specialized_turbo')
                     and state.state not in ['unknown', 'unavailable']
                     and state.state | float(0) >= 1
                     and state.state | float(0) < 99 %}
                    {{ state.name }}: {{ state.state }}%
                  {% endif %}
                {% endfor %}
              '';
              data = {
                tag = "bike_charging";
                live_update = true;
                alert_once = true;
                notification_icon = "mdi:bike";
                critical_text = ''
                  {% for state in states.sensor %}
                    {% if state.attributes.device_class is defined
                       and state.attributes.device_class == 'battery'
                       and state.entity_id.startswith('sensor.specialized_turbo')
                       and state.state not in ['unknown', 'unavailable']
                       and state.state | float(0) >= 1
                       and state.state | float(0) < 99 %}
                      {{ state.state }}%
                    {% endif %}
                  {% endfor %}
                '';
                progress = ''
                  {% for state in states.sensor %}
                    {% if state.attributes.device_class is defined
                       and state.attributes.device_class == 'battery'
                       and state.entity_id.startswith('sensor.specialized_turbo')
                       and state.state not in ['unknown', 'unavailable']
                       and state.state | float(0) >= 1
                       and state.state | float(0) < 99 %}
                      {{ state.state | int(0) }}
                    {% endif %}
                  {% endfor %}
                '';
                progress_max = 100;
              };
            };
          }
        ];
      }
      {
        alias = "Clear bike battery charging notification";
        id = "bike_battery_charging_clear";
        triggers = [
          {
            trigger = "template";
            value_template = ''
              {% set sensors = [
                states('sensor.specialized_turbo_jamie_battery'),
                states('sensor.specialized_turbo_kat_battery')
              ] %}
              {{ sensors | map('float', 0) | select('ge', 1) | select('lt', 99) | list | count == 0 }}
            '';
            for = {
              minutes = 1;
            };
          }
        ];
        actions = [
          {
            action = "notify.everyone";
            data = {
              message = "clear_notification";
              data = {
                tag = "bike_charging";
              };
            };
          }
        ];
      }
    ];
  };
}
