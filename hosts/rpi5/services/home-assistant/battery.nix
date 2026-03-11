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
            trigger = "time_pattern";
            minutes = "/5";
          }
        ];
        conditions = [
          {
            condition = "template";
            value_template = ''
              {% for state in states.sensor %}
                {% if state.attributes.device_class is defined
                   and state.attributes.device_class == 'battery'
                   and state.entity_id.startswith('sensor.specialized_turbo')
                   and state.state not in ['unknown', 'unavailable']
                   and state.state | float(0) >= 1
                   and state.state | float(0) < 99 %}
                  true
                {% endif %}
              {% endfor %}
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
            trigger = "time_pattern";
            minutes = "/5";
          }
        ];
        conditions = [
          {
            condition = "template";
            value_template = ''
              {% set ns = namespace(charging=false) %}
              {% for state in states.sensor %}
                {% if state.attributes.device_class is defined
                   and state.attributes.device_class == 'battery'
                   and state.entity_id.startswith('sensor.specialized_turbo')
                   and state.state not in ['unknown', 'unavailable']
                   and state.state | float(0) >= 1
                   and state.state | float(0) < 99 %}
                  {% set ns.charging = true %}
                {% endif %}
              {% endfor %}
              {{ not ns.charging }}
            '';
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
