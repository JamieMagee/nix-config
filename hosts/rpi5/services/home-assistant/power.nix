{
  services.home-assistant = {
    extraComponents = [
      "opower"
    ];

    config = {
      sensor = [
        {
          platform = "integration";
          source = "sensor.total_lights_power";
          name = "Total Lights Energy";
          unique_id = "total_lights_energy";
          unit_prefix = "k";
          unit_time = "h";
          round = 2;
          method = "left";
        }
      ];

      template = [
        {
          sensor = [
            # Seattle City Light electricity price sensors
            # Rates from: https://www.seattle.gov/city-light/residential-services/billing-information/rates
            {
              name = "SCL Flat Rate Price";
              unique_id = "scl_flat_rate_price";
              unit_of_measurement = "USD/kWh";
              icon = "mdi:currency-usd";
              state = "0.1392";
            }
            {
              name = "SCL TOU Price";
              unique_id = "scl_tou_price";
              unit_of_measurement = "USD/kWh";
              icon = "mdi:currency-usd";
              # Peak:     5pm-9pm Mon-Sat (not holidays) = $0.1674
              # Mid-Peak: 6am-5pm & 9pm-midnight Mon-Sat; 6am-midnight Sun/holidays = $0.1465
              # Off-Peak: midnight-6am every day = $0.0837
              state = ''
                {% set h = now().hour %}
                {% set wd = now().weekday() %}
                {% set is_sunday = (wd == 6) %}
                {% if h >= 0 and h < 6 %}
                  0.0837
                {% elif is_sunday %}
                  0.1465
                {% elif h >= 17 and h < 21 %}
                  0.1674
                {% else %}
                  0.1465
                {% endif %}
              '';
            }
            {
              name = "SCL TOU Period";
              unique_id = "scl_tou_period";
              icon = "mdi:clock-outline";
              state = ''
                {% set h = now().hour %}
                {% set wd = now().weekday() %}
                {% set is_sunday = (wd == 6) %}
                {% if h >= 0 and h < 6 %}
                  Off-Peak
                {% elif is_sunday %}
                  Mid-Peak
                {% elif h >= 17 and h < 21 %}
                  Peak
                {% else %}
                  Mid-Peak
                {% endif %}
              '';
            }
            {
              name = "SCL Estimated Daily Cost (Flat)";
              unique_id = "scl_estimated_daily_cost_flat";
              unit_of_measurement = "USD";
              device_class = "monetary";
              state_class = "total";
              icon = "mdi:cash";
              # Base service charge + usage-to-date cost from Opower
              state = ''
                {% set base = 0.4103 %}
                {% set usage = states('sensor.current_bill_electric_cost_to_date') | float(0) %}
                {% set start = states('sensor.current_bill_electric_start_date') %}
                {% if start not in ['unknown', 'unavailable'] %}
                  {% set days = ((as_timestamp(now()) - as_timestamp(start)) / 86400) | round(0, 'ceil') %}
                  {% if days > 0 %}
                    {{ ((usage / days) + base) | round(2) }}
                  {% else %}
                    {{ base }}
                  {% endif %}
                {% else %}
                  {{ base }}
                {% endif %}
              '';
            }
            {
              name = "Total Lights Power";
              unique_id = "total_lights_power";
              unit_of_measurement = "W";
              device_class = "power";
              state_class = "measurement";
              state = ''
                {% set switches = [
                  'sensor.garage_switch_outdoors_power',
                  'sensor.garage_switch_indoors_power',
                  'sensor.garage_bathroom_switch_light_power',
                  'sensor.garage_hallway_switch_stairs_power',
                  'sensor.kitchen_switch_stairs_light_power',
                  'sensor.kitchen_switch_kitchen_light_power',
                  'sensor.kitchen_switch_living_room_light_power',
                  'sensor.living_room_switch_living_room_light_power',
                  'sensor.living_room_switch_kitchen_light_power',
                  'sensor.living_room_switch_stairs_light_power',
                  'sensor.living_room_switch_front_porch_power',
                  'sensor.upstairs_switch_hallway_light_1_power',
                  'sensor.upstairs_switch_hallway_light_2_power',
                  'sensor.upstairs_switch_stairs_light_power',
                  'sensor.upstairs_switch_rooftop_power',
                  'sensor.bedroom_switch_power',
                  'sensor.bedroom_switch_closet_power',
                  'sensor.office_switch_power',
                  'sensor.bathroom_switch_overhead_1_power',
                  'sensor.bathroom_switch_overhead_2_power',
                  'sensor.bathroom_switch_vanity_1_power',
                  'sensor.bathroom_switch_vanity_2_power',
                  'sensor.kitchen_switch_balcony_power'
                ] %}
                {% set total = namespace(value=0) %}
                {% for switch in switches %}
                  {% set total.value = total.value + (states(switch) | float(0)) %}
                {% endfor %}
                {{ total.value | round(2) }}
              '';
            }
            # Average power per active switch
            {
              name = "Average Lights Power";
              unique_id = "average_lights_power";
              unit_of_measurement = "W";
              device_class = "power";
              state_class = "measurement";
              state = ''
                {% set switches = [
                  'sensor.garage_switch_outdoors_power',
                  'sensor.garage_switch_indoors_power',
                  'sensor.garage_bathroom_switch_light_power',
                  'sensor.garage_hallway_switch_stairs_power',
                  'sensor.kitchen_switch_stairs_light_power',
                  'sensor.kitchen_switch_kitchen_light_power',
                  'sensor.kitchen_switch_living_room_light_power',
                  'sensor.living_room_switch_living_room_light_power',
                  'sensor.living_room_switch_kitchen_light_power',
                  'sensor.living_room_switch_stairs_light_power',
                  'sensor.living_room_switch_front_porch_power',
                  'sensor.upstairs_switch_hallway_light_1_power',
                  'sensor.upstairs_switch_hallway_light_2_power',
                  'sensor.upstairs_switch_stairs_light_power',
                  'sensor.upstairs_switch_rooftop_power',
                  'sensor.bedroom_switch_power',
                  'sensor.bedroom_switch_closet_power',
                  'sensor.office_switch_power',
                  'sensor.bathroom_switch_overhead_1_power',
                  'sensor.bathroom_switch_overhead_2_power',
                  'sensor.bathroom_switch_vanity_1_power',
                  'sensor.bathroom_switch_vanity_2_power',
                  'sensor.kitchen_switch_balcony_power'
                ] %}
                {% set total = namespace(value=0, count=0) %}
                {% for switch in switches %}
                  {% set power = states(switch) | float(0) %}
                  {% if power > 0 %}
                    {% set total.value = total.value + power %}
                    {% set total.count = total.count + 1 %}
                  {% endif %}
                {% endfor %}
                {% if total.count > 0 %}
                  {{ (total.value / total.count) | round(2) }}
                {% else %}
                  0
                {% endif %}
              '';
            }
          ];
        }
      ];
    };
  };
}
