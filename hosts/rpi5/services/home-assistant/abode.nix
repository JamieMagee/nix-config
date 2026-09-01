let
  vacuumActiveStates = [
    "cleaning"
    "paused"
    "returning"
  ];
  vacuumFinishedStates = [
    "docked"
    "idle"
  ];
in
{
  services.home-assistant = {
    extraComponents = [ "abode" ];

    config = {
      input_boolean = {
        vacuum_alarm_override = {
          name = "Vacuum Alarm Override";
          icon = "mdi:robot-vacuum";
        };
      };

      binary_sensor = [
        {
          platform = "group";
          name = "Doors";
          entities = [
            "binary_sensor.front_door"
            "binary_sensor.balcony_door"
            "binary_sensor.garage_door"
          ];
        }
        {
          platform = "group";
          name = "Windows";
          entities = [ "binary_sensor.front_window" ];
        }
      ];

      automation = [
        {
          alias = "Notify on alarm change";
          id = "alarm_state_change";
          triggers = [
            {
              trigger = "state";
              entity_id = "alarm_control_panel.abode_alarm";
              not_from = [
                "unknown"
                "unavailable"
              ];
              to = null;
            }
          ];
          conditions = [
            {
              condition = "not";
              conditions = [
                {
                  condition = "state";
                  entity_id = "alarm_control_panel.abode_alarm";
                  state = "unavailable";
                }
              ];
            }
            {
              condition = "or";
              conditions = [
                {
                  condition = "not";
                  conditions = [
                    {
                      condition = "state";
                      entity_id = "alarm_control_panel.abode_alarm";
                      state = [
                        "arming"
                        "pending"
                        "armed_home"
                        "armed_away"
                      ];
                    }
                  ];
                }
                {
                  condition = "and";
                  conditions = [
                    {
                      condition = "state";
                      entity_id = "input_boolean.vacuum_alarm_override";
                      state = "off";
                    }
                    {
                      condition = "not";
                      conditions = [
                        {
                          condition = "and";
                          conditions = [
                            {
                              condition = "state";
                              entity_id = "zone.home";
                              state = "0";
                            }
                            {
                              condition = "state";
                              entity_id = "vacuum.s7_max_ultra";
                              state = vacuumActiveStates;
                            }
                          ];
                        }
                      ];
                    }
                  ];
                }
              ];
            }
          ];

          actions = [
            {
              action = "notify.everyone";
              data = {
                title = "Alarm";
                message = ''
                  {%- if is_state("alarm_control_panel.abode_alarm", "armed_away") -%}
                    No-one is home. The alarm is armed
                  {%- elif is_state("alarm_control_panel.abode_alarm", "disarmed") -%}
                    Alarm disabled
                  {%- elif is_state("alarm_control_panel.abode_alarm", "armed_home") -%}
                    The alarm is armed home.
                  {%- endif %}
                '';
                data = {
                  tag = "alarm_state";
                  notification_icon = "mdi:shield-home";
                };
              };
            }
          ];
        }
        {
          alias = "Arm alarm at night";
          id = "arm_alarm_night";
          triggers = [
            {
              trigger = "time";
              at = "22:00:00";
            }
          ];
          conditions = {
            condition = "or";
            conditions = [
              {
                condition = "state";
                entity_id = [
                  "person.jamie"
                ];
                state = "home";
              }
              {
                condition = "state";
                entity_id = [
                  "person.kat"
                ];
                state = "home";
              }
            ];
          };
          actions = [
            {
              action = "alarm_control_panel.alarm_arm_home";
              entity_id = "alarm_control_panel.abode_alarm";
            }
          ];
        }
        {
          alias = "Notify when alarm disarmed overnight";
          id = "alarm_disarmed_overnight";
          triggers = [
            {
              trigger = "state";
              entity_id = "alarm_control_panel.abode_alarm";
              from = "armed_away";
              to = "disarmed";
            }
          ];
          conditions = [
            {
              condition = "time";
              after = "22:00:00";
              before = "07:00:00";
            }
          ];
          actions = [
            {
              action = "notify.everyone";
              data = {
                title = "Alarm";
                message = "Don't forget to re-arm the alarm!";
                data = {
                  tag = "alarm_disarmed_overnight";
                  notification_icon = "mdi:shield-alert";
                };
              };
            }
          ];
        }
        {
          alias = "Arm alarm when no-one home";
          id = "arm_alarm_no_one_home";
          triggers = [
            {
              trigger = "state";
              entity_id = "zone.home";
              to = "0";
              for = {
                minutes = 1;
              };
            }
          ];
          actions = [
            {
              choose = [
                {
                  conditions = [
                    {
                      condition = "state";
                      entity_id = "vacuum.s7_max_ultra";
                      state = vacuumActiveStates;
                    }
                  ];
                  sequence = [
                    {
                      action = "input_boolean.turn_on";
                      target = {
                        entity_id = "input_boolean.vacuum_alarm_override";
                      };
                    }
                    {
                      action = "alarm_control_panel.alarm_arm_home";
                      target = {
                        entity_id = "alarm_control_panel.abode_alarm";
                      };
                    }
                  ];
                }
              ];
              default = [
                {
                  action = "input_boolean.turn_off";
                  target = {
                    entity_id = "input_boolean.vacuum_alarm_override";
                  };
                }
                {
                  action = "alarm_control_panel.alarm_arm_away";
                  target = {
                    entity_id = "alarm_control_panel.abode_alarm";
                  };
                }
              ];
            }
          ];
        }
        {
          alias = "Keep alarm home while vacuum is active";
          id = "alarm_home_vacuum_active";
          description = "Use armed-home while the Roborock is moving through an empty house.";
          triggers = [
            {
              trigger = "state";
              entity_id = "vacuum.s7_max_ultra";
              to = vacuumActiveStates;
            }
            {
              trigger = "state";
              entity_id = "alarm_control_panel.abode_alarm";
              to = "armed_away";
            }
            {
              trigger = "homeassistant";
              event = "start";
            }
          ];
          conditions = [
            {
              condition = "state";
              entity_id = "zone.home";
              state = "0";
            }
            {
              condition = "state";
              entity_id = "vacuum.s7_max_ultra";
              state = vacuumActiveStates;
            }
            {
              condition = "state";
              entity_id = "alarm_control_panel.abode_alarm";
              state = "armed_away";
            }
          ];
          actions = [
            {
              action = "input_boolean.turn_on";
              target = {
                entity_id = "input_boolean.vacuum_alarm_override";
              };
            }
            {
              action = "alarm_control_panel.alarm_arm_home";
              target = {
                entity_id = "alarm_control_panel.abode_alarm";
              };
            }
          ];
          mode = "restart";
        }
        {
          alias = "Restore away alarm after vacuum finishes";
          id = "restore_alarm_away_vacuum_finished";
          description = "Restore armed-away after the Roborock finishes, unless occupancy or the alarm state changed.";
          triggers = [
            {
              trigger = "state";
              entity_id = "vacuum.s7_max_ultra";
              to = vacuumFinishedStates;
            }
            {
              trigger = "homeassistant";
              event = "start";
            }
          ];
          conditions = [
            {
              condition = "state";
              entity_id = "input_boolean.vacuum_alarm_override";
              state = "on";
            }
            {
              condition = "state";
              entity_id = "vacuum.s7_max_ultra";
              state = vacuumFinishedStates;
            }
          ];
          actions = [
            {
              choose = [
                {
                  conditions = [
                    {
                      condition = "state";
                      entity_id = "zone.home";
                      state = "0";
                    }
                    {
                      condition = "state";
                      entity_id = "alarm_control_panel.abode_alarm";
                      state = "armed_home";
                    }
                  ];
                  sequence = [
                    {
                      action = "alarm_control_panel.alarm_arm_away";
                      target = {
                        entity_id = "alarm_control_panel.abode_alarm";
                      };
                    }
                  ];
                }
              ];
              default = [
                {
                  action = "input_boolean.turn_off";
                  target = {
                    entity_id = "input_boolean.vacuum_alarm_override";
                  };
                }
              ];
            }
          ];
          mode = "restart";
        }
        {
          alias = "Clear vacuum alarm override";
          id = "clear_vacuum_alarm_override";
          description = "Clear the vacuum override after the alarm settles, is disarmed, or the house becomes occupied.";
          triggers = [
            {
              trigger = "state";
              entity_id = "alarm_control_panel.abode_alarm";
              to = "armed_away";
              for = {
                seconds = 2;
              };
            }
            {
              trigger = "state";
              entity_id = "alarm_control_panel.abode_alarm";
              to = "disarmed";
            }
            {
              trigger = "state";
              entity_id = "zone.home";
              from = "0";
              not_to = [
                "unknown"
                "unavailable"
              ];
            }
            {
              trigger = "homeassistant";
              event = "start";
            }
          ];
          conditions = [
            {
              condition = "state";
              entity_id = "input_boolean.vacuum_alarm_override";
              state = "on";
            }
            {
              condition = "or";
              conditions = [
                {
                  condition = "and";
                  conditions = [
                    {
                      condition = "state";
                      entity_id = "alarm_control_panel.abode_alarm";
                      state = "armed_away";
                    }
                    {
                      condition = "state";
                      entity_id = "vacuum.s7_max_ultra";
                      state = vacuumFinishedStates;
                    }
                  ];
                }
                {
                  condition = "state";
                  entity_id = "alarm_control_panel.abode_alarm";
                  state = "disarmed";
                }
                {
                  condition = "not";
                  conditions = [
                    {
                      condition = "state";
                      entity_id = "zone.home";
                      state = [
                        "0"
                        "unknown"
                        "unavailable"
                      ];
                    }
                  ];
                }
              ];
            }
          ];
          actions = [
            {
              action = "input_boolean.turn_off";
              target = {
                entity_id = "input_boolean.vacuum_alarm_override";
              };
            }
          ];
          mode = "restart";
        }
        {
          alias = "Disarm alarm in the morning";
          id = "disarm_alarm_morning";
          triggers = [
            {
              trigger = "time";
              at = "sensor.kat_pixel_8a_next_alarm";
              id = "kat";
            }
            {
              trigger = "time";
              at = "sensor.jamie_pixel_8a_next_alarm";
              id = "jamie";
            }
          ];
          conditions = [
            {
              condition = "template";
              value_template = "{{ is_state('person.' ~ trigger.id, 'home') }}";
            }
          ];
          actions = [
            {
              action = "alarm_control_panel.alarm_disarm";
              entity_id = "alarm_control_panel.abode_alarm";
            }
          ];
        }
      ];
    };
  };
}
