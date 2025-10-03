{
  services.home-assistant = {
    extraComponents = [
      "opower"
    ];

    config = {
      template = [
        {
          sensor = [
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
            {
              name = "Total Lights Energy";
              unique_id = "total_lights_energy";
              unit_of_measurement = "kWh";
              device_class = "energy";
              state_class = "total_increasing";
              state = ''
                {% set switches = [
                  'sensor.garage_switch_outdoors_energy',
                  'sensor.garage_switch_indoors_energy',
                  'sensor.garage_bathroom_switch_light_energy',
                  'sensor.garage_hallway_switch_stairs_energy',
                  'sensor.kitchen_switch_stairs_light_energy',
                  'sensor.kitchen_switch_kitchen_light_energy',
                  'sensor.kitchen_switch_living_room_light_energy',
                  'sensor.living_room_switch_living_room_light_energy',
                  'sensor.living_room_switch_kitchen_light_energy',
                  'sensor.living_room_switch_stairs_light_energy',
                  'sensor.living_room_switch_front_porch_energy',
                  'sensor.upstairs_switch_hallway_light_1_energy',
                  'sensor.upstairs_switch_hallway_light_2_energy',
                  'sensor.upstairs_switch_stairs_light_energy',
                  'sensor.upstairs_switch_rooftop_energy',
                  'sensor.bedroom_switch_energy',
                  'sensor.bedroom_switch_closet_energy',
                  'sensor.office_switch_energy',
                  'sensor.bathroom_switch_overhead_1_energy',
                  'sensor.bathroom_switch_overhead_2_energy',
                  'sensor.bathroom_switch_vanity_1_energy',
                  'sensor.bathroom_switch_vanity_2_energy',
                  'sensor.kitchen_switch_balcony_energy'
                ] %}
                {% set total = namespace(value=0) %}
                {% for switch in switches %}
                  {% set total.value = total.value + (states(switch) | float(0)) %}
                {% endfor %}
                {{ total.value | round(3) }}
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
