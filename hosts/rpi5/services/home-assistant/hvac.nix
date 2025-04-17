{
  services.home-assistant.config = {
    automation = [
      {
        alias = "Turn off HVAC when no one is home";
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
            action = "climate.set_hvac_mode";
            target = {
              entity_id = [
                "climate.esphome_web_6c4990_bedroom_mini_split"
                "climate.esphome_web_6ab408_office_mini_split"
                "climate.esphome_web_6c37b0_downstairs_mini_split"
                "climate.mysa_89501c_thermostat"
                "climate.mysa_2bbd00_thermostat"
              ];
            };
            data = {
              hvac_mode = "off";
            };
          }
        ];
      }
      {
        alias = "Turn off garage heat overnight";
        id = "garage_heat_overnight";
        triggers = [
          {
            trigger = "time";
            at = "22:00:00";
          }
        ];
        actions = [
          {
            action = "scene.create";
            data = {
              scene_id = "garage_climate_before";
              snapshot_entities = [
                "climate.mysa_89501c_thermostat"
                "climate.mysa_2bbd00_thermostat"
              ];
            };
          }
          {
            action = "climate.set_hvac_mode";
            target = {
              entity_id = [
                "climate.mysa_89501c_thermostat"
                "climate.mysa_2bbd00_thermostat"
              ];
            };
            data = {
              hvac_mode = "off";
            };
          }
        ];
      }
      {
        alias = "Turn on garage heat in the morning";
        id = "garage_heat_morning";
        triggers = [
          {
            trigger = "time";
            at = "06:00:00";
          }
        ];
        conditions = [
          {
            condition = "numeric_state";
            entity_id = "zone.home";
            above = 0;
          }
        ];
        actions = [
          {
            action = "scene.turn_on";
            target = {
              entity_id = "scene.garage_climate_before";
            };
          }
        ];
      }
      {
        alias = "Turn on bathroom fan when humidity is high";
        id = "bathroom_fan_humidity";
        triggers = [
          {
            trigger = "numeric_state";
            entity_id = "sensor.0x00158d008b7ca529_humidity";
            above = 60;
          }
        ];
        actions = [
          {
            action = "fan.turn_on";
            target = {
              entity_id = "fan.0x048727fffe1b2e4d";
            };
          }
        ];
      }
      {
        alias = "Turn off bathroom fan when humidity is low";
        id = "bathroom_fan_humidity_off";
        triggers = [
          {
            trigger = "numeric_state";
            entity_id = "sensor.0x00158d008b7ca529_humidity";
            below = 55;
          }
        ];
        actions = [
          {
            action = "fan.turn_off";
            target = {
              entity_id = "fan.0x048727fffe1b2e4d";
            };
          }
        ];
      }
      {
        alias = "Mini Split - Turn Off At Night";
        id = "mini_split_night_off";
        triggers = [
          {
            trigger = "time";
            at = "22:00:00";
          }
        ];
        conditions = [
          {
            condition = "numeric_state";
            entity_id = "zone.home";
            above = 0;
          }
        ];
        actions = [
          {
            action = "climate.set_hvac_mode";
            target = {
              entity_id = [
                "climate.esphome_web_6ab408_office_mini_split"
                "climate.esphome_web_6c37b0_downstairs_mini_split"
              ];
            };
            data = {
              hvac_mode = "off";
            };
          }
          {
            action = "climate.set_hvac_mode";
            target = {
              entity_id = "climate.esphome_web_6c4990_bedroom_mini_split";
            };
            data = {
              hvac_mode = "cool";
            };
          }
          {
            action = "climate.set_temperature";
            target = {
              entity_id = "climate.esphome_web_6c4990_bedroom_mini_split";
            };
            data = {
              temperature = 20;
            };
          }
          {
            action = "climate.set_fan_mode";
            target = {
              entity_id = "climate.esphome_web_6c4990_bedroom_mini_split";
            };
            data = {
              fan_mode = "low";
            };
          }
        ];
      }
      {
        alias = "Mini Split - Mode Coordinator";
        id = "hvac_mode_coordinator";
        triggers = [
          {
            trigger = "time_pattern";
            minutes = "/10";
          }
        ];
        conditions = [
          {
            condition = "numeric_state";
            entity_id = "zone.home";
            above = 0;
          }
          {
            condition = "time";
            after = "06:00:00";
            before = "22:00:00";
          }
        ];
        actions = [
          {
            action = "script.determine_hvac_mode";
          }
        ];
      }
    ];
    script = {
      determine_hvac_mode = {
        alias = "Determine HVAC Mode Per Zone";
        sequence = [
          # Store current temperatures in variables
          {
            variables = {
              bedroom_temp = "{{ state_attr('climate.esphome_web_6c4990_bedroom_mini_split', 'current_temperature') | float(0) }}";
              office_temp = "{{ state_attr('climate.esphome_web_6ab408_office_mini_split', 'current_temperature') | float(0) }}";
              downstairs_temp = "{{ state_attr('climate.esphome_web_6c37b0_downstairs_mini_split', 'current_temperature') | float(0) }}";
            };
          }
          # Create a map of what each unit needs
          {
            variables = {
              bedroom_need = "{% if bedroom_temp < 21.5 %}heat{% elif bedroom_temp > 24.5 %}cool{% else %}fan{% endif %}";
              office_need = "{% if office_temp < 21.5 %}heat{% elif office_temp > 24.5 %}cool{% else %}fan{% endif %}";
              downstairs_need = "{% if downstairs_temp < 21.5 %}heat{% elif downstairs_temp > 24.5 %}cool{% else %}fan{% endif %}";
            };
          }
          # Count needs
          {
            variables = {
              heat_count = "{{ [bedroom_need == 'heat', office_need == 'heat', downstairs_need == 'heat'] | select('==', true) | list | count }}";
              cool_count = "{{ [bedroom_need == 'cool', office_need == 'cool', downstairs_need == 'cool'] | select('==', true) | list | count }}";
              fan_count = "{{ [bedroom_need == 'fan', office_need == 'fan', downstairs_need == 'fan'] | select('==', true) | list | count }}";
            };
          }
          # First check for conflicts between heat and cool
          {
            "if" = [
              {
                condition = "template";
                value_template = "{{ heat_count > 0 and cool_count > 0 }}";
              }
            ];
            "then" = [
              # If more units need heat than cool
              {
                "if" = [
                  {
                    condition = "template";
                    value_template = "{{ heat_count > cool_count }}";
                  }
                ];
                "then" = [
                  # Set units that need heat to heat
                  {
                    "if" = [
                      {
                        condition = "template";
                        value_template = "{{ bedroom_need == 'heat' }}";
                      }
                    ];
                    "then" = [
                      {
                        action = "climate.set_hvac_mode";
                        target = {
                          entity_id = "climate.esphome_web_6c4990_bedroom_mini_split";
                        };
                        data = {
                          hvac_mode = "heat";
                        };
                      }
                      {
                        action = "climate.set_temperature";
                        target = {
                          entity_id = "climate.esphome_web_6c4990_bedroom_mini_split";
                        };
                        data = {
                          temperature = 22;
                        };
                      }
                      {
                        action = "climate.set_fan_mode";
                        target = {
                          entity_id = "climate.esphome_web_6c4990_bedroom_mini_split";
                        };
                        data = {
                          fan_mode = "auto";
                        };
                      }
                    ];
                  }
                  {
                    "if" = [
                      {
                        condition = "template";
                        value_template = "{{ office_need == 'heat' }}";
                      }
                    ];
                    "then" = [
                      {
                        action = "climate.set_hvac_mode";
                        target = {
                          entity_id = "climate.esphome_web_6ab408_office_mini_split";
                        };
                        data = {
                          hvac_mode = "heat";
                        };
                      }
                      {
                        action = "climate.set_temperature";
                        target = {
                          entity_id = "climate.esphome_web_6ab408_office_mini_split";
                        };
                        data = {
                          temperature = 22;
                        };
                      }
                      {
                        action = "climate.set_fan_mode";
                        target = {
                          entity_id = "climate.esphome_web_6ab408_office_mini_split";
                        };
                        data = {
                          fan_mode = "auto";
                        };
                      }
                    ];
                  }
                  {
                    "if" = [
                      {
                        condition = "template";
                        value_template = "{{ downstairs_need == 'heat' }}";
                      }
                    ];
                    "then" = [
                      {
                        action = "climate.set_hvac_mode";
                        target = {
                          entity_id = "climate.esphome_web_6c37b0_downstairs_mini_split";
                        };
                        data = {
                          hvac_mode = "heat";
                        };
                      }
                      {
                        action = "climate.set_temperature";
                        target = {
                          entity_id = "climate.esphome_web_6c37b0_downstairs_mini_split";
                        };
                        data = {
                          temperature = 22;
                        };
                      }
                      {
                        action = "climate.set_fan_mode";
                        target = {
                          entity_id = "climate.esphome_web_6c37b0_downstairs_mini_split";
                        };
                        data = {
                          fan_mode = "auto";
                        };
                      }
                    ];
                  }
                  # Set units that need cool to fan
                  {
                    "if" = [
                      {
                        condition = "template";
                        value_template = "{{ bedroom_need == 'cool' }}";
                      }
                    ];
                    "then" = [
                      {
                        action = "climate.set_hvac_mode";
                        target = {
                          entity_id = "climate.esphome_web_6c4990_bedroom_mini_split";
                        };
                        data = {
                          hvac_mode = "fan_only";
                        };
                      }
                      {
                        action = "climate.set_fan_mode";
                        target = {
                          entity_id = "climate.esphome_web_6c4990_bedroom_mini_split";
                        };
                        data = {
                          fan_mode = "auto";
                        };
                      }
                    ];
                  }
                  {
                    "if" = [
                      {
                        condition = "template";
                        value_template = "{{ office_need == 'cool' }}";
                      }
                    ];
                    "then" = [
                      {
                        action = "climate.set_hvac_mode";
                        target = {
                          entity_id = "climate.esphome_web_6ab408_office_mini_split";
                        };
                        data = {
                          hvac_mode = "fan_only";
                        };
                      }
                      {
                        action = "climate.set_fan_mode";
                        target = {
                          entity_id = "climate.esphome_web_6ab408_office_mini_split";
                        };
                        data = {
                          fan_mode = "auto";
                        };
                      }
                    ];
                  }
                  {
                    "if" = [
                      {
                        condition = "template";
                        value_template = "{{ downstairs_need == 'cool' }}";
                      }
                    ];
                    "then" = [
                      {
                        action = "climate.set_hvac_mode";
                        target = {
                          entity_id = "climate.esphome_web_6c37b0_downstairs_mini_split";
                        };
                        data = {
                          hvac_mode = "fan_only";
                        };
                      }
                      {
                        action = "climate.set_fan_mode";
                        target = {
                          entity_id = "climate.esphome_web_6c37b0_downstairs_mini_split";
                        };
                        data = {
                          fan_mode = "auto";
                        };
                      }
                    ];
                  }
                ];
              }
              # If more units need cool than heat
              {
                "if" = [
                  {
                    condition = "template";
                    value_template = "{{ cool_count > heat_count }}";
                  }
                ];
                "then" = [
                  # Set units that need cool to cool
                  {
                    "if" = [
                      {
                        condition = "template";
                        value_template = "{{ bedroom_need == 'cool' }}";
                      }
                    ];
                    "then" = [
                      {
                        action = "climate.set_hvac_mode";
                        target = {
                          entity_id = "climate.esphome_web_6c4990_bedroom_mini_split";
                        };
                        data = {
                          hvac_mode = "cool";
                        };
                      }
                      {
                        action = "climate.set_temperature";
                        target = {
                          entity_id = "climate.esphome_web_6c4990_bedroom_mini_split";
                        };
                        data = {
                          temperature = 24;
                        };
                      }
                      {
                        action = "climate.set_fan_mode";
                        target = {
                          entity_id = "climate.esphome_web_6c4990_bedroom_mini_split";
                        };
                        data = {
                          fan_mode = "auto";
                        };
                      }
                    ];
                  }
                  {
                    "if" = [
                      {
                        condition = "template";
                        value_template = "{{ office_need == 'cool' }}";
                      }
                    ];

                    "then" = [
                      {
                        action = "climate.set_hvac_mode";
                        target = {
                          entity_id = "climate.esphome_web_6ab408_office_mini_split";
                        };
                        data = {
                          hvac_mode = "cool";
                        };
                      }
                      {
                        action = "climate.set_temperature";
                        target = {
                          entity_id = "climate.esphome_web_6ab408_office_mini_split";
                        };
                        data = {
                          temperature = 24;
                        };
                      }
                      {
                        action = "climate.set_fan_mode";
                        target = {
                          entity_id = "climate.esphome_web_6ab408_office_mini_split";
                        };
                        data = {
                          fan_mode = "auto";
                        };
                      }
                    ];
                  }
                  {
                    "if" = [
                      {
                        condition = "template";
                        value_template = "{{ downstairs_need == 'cool' }}";
                      }
                    ];
                    "then" = [
                      {
                        action = "climate.set_hvac_mode";
                        target = {
                          entity_id = "climate.esphome_web_6c37b0_downstairs_mini_split";
                        };
                        data = {
                          hvac_mode = "cool";
                        };
                      }
                      {
                        action = "climate.set_temperature";
                        target = {
                          entity_id = "climate.esphome_web_6c37b0_downstairs_mini_split";
                        };
                        data = {
                          temperature = 24;
                        };
                      }
                      {
                        action = "climate.set_fan_mode";
                        target = {
                          entity_id = "climate.esphome_web_6c37b0_downstairs_mini_split";
                        };
                        data = {
                          fan_mode = "auto";
                        };
                      }
                    ];
                  }
                  # Set units that need heat to fan
                  {
                    "if" = [
                      {
                        condition = "template";
                        value_template = "{{ bedroom_need == 'heat' }}";
                      }
                    ];
                    "then" = [
                      {
                        action = "climate.set_hvac_mode";
                        target = {
                          entity_id = "climate.esphome_web_6c4990_bedroom_mini_split";
                        };
                        data = {
                          hvac_mode = "fan_only";
                        };
                      }
                      {
                        action = "climate.set_fan_mode";
                        target = {
                          entity_id = "climate.esphome_web_6c4990_bedroom_mini_split";
                        };
                        data = {
                          fan_mode = "auto";
                        };
                      }
                    ];
                  }
                  {
                    "if" = [
                      {
                        condition = "template";
                        value_template = "{{ office_need == 'heat' }}";
                      }
                    ];
                    "then" = [
                      {
                        action = "climate.set_hvac_mode";
                        target = {
                          entity_id = "climate.esphome_web_6ab408_office_mini_split";
                        };
                        data = {
                          hvac_mode = "fan_only";
                        };
                      }
                      {
                        action = "climate.set_fan_mode";
                        target = {
                          entity_id = "climate.esphome_web_6ab408_office_mini_split";
                        };
                        data = {
                          fan_mode = "auto";
                        };
                      }
                    ];
                  }
                  {
                    "if" = [
                      {
                        condition = "template";
                        value_template = "{{ downstairs_need == 'heat' }}";
                      }
                    ];
                    "then" = [
                      {
                        action = "climate.set_hvac_mode";
                        target = {
                          entity_id = "climate.esphome_web_6c37b0_downstairs_mini_split";
                        };
                        data = {
                          hvac_mode = "fan_only";
                        };
                      }
                      {
                        action = "climate.set_fan_mode";
                        target = {
                          entity_id = "climate.esphome_web_6c37b0_downstairs_mini_split";
                        };
                        data = {
                          fan_mode = "auto";
                        };
                      }
                    ];
                  }
                ];
              }
              # If equal heat and cool needs, set all to fan
              {
                "if" = [
                  {
                    condition = "template";
                    value_template = "{{ heat_count == cool_count }}";
                  }
                ];
                "then" = [
                  {
                    action = "climate.set_hvac_mode";
                    target = {
                      entity_id = [
                        "climate.esphome_web_6c4990_bedroom_mini_split"
                        "climate.esphome_web_6ab408_office_mini_split"
                        "climate.esphome_web_6c37b0_downstairs_mini_split"
                      ];
                    };
                    data = {
                      hvac_mode = "fan_only";
                    };
                  }
                  {
                    action = "climate.set_fan_mode";
                    target = {
                      entity_id = [
                        "climate.esphome_web_6c4990_bedroom_mini_split"
                        "climate.esphome_web_6ab408_office_mini_split"
                        "climate.esphome_web_6c37b0_downstairs_mini_split"
                      ];
                    };
                    data = {
                      fan_mode = "auto";
                    };
                  }
                ];
              }
            ];
          }
          # If no conflicts (all need the same or fan), set as requested
          {
            "if" = [
              {
                condition = "template";
                value_template = "{{ heat_count == 0 or cool_count == 0 }}";
              }
            ];
            "then" = [
              # Set bedroom as needed
              {
                "if" = [
                  {
                    condition = "template";
                    value_template = "{{ bedroom_need == 'heat' }}";
                  }
                ];
                "then" = [
                  {
                    action = "climate.set_hvac_mode";
                    target = {
                      entity_id = "climate.esphome_web_6c4990_bedroom_mini_split";
                    };
                    data = {
                      hvac_mode = "heat";
                    };
                  }
                  {
                    action = "climate.set_temperature";
                    target = {
                      entity_id = "climate.esphome_web_6c4990_bedroom_mini_split";
                    };
                    data = {
                      temperature = 22;
                    };
                  }
                  {
                    action = "climate.set_fan_mode";
                    target = {
                      entity_id = "climate.esphome_web_6c4990_bedroom_mini_split";
                    };
                    data = {
                      fan_mode = "auto";
                    };
                  }
                ];
              }
              {
                "if" = [
                  {
                    condition = "template";
                    value_template = "{{ bedroom_need == 'cool' }}";
                  }
                ];
                "then" = [
                  {
                    action = "climate.set_hvac_mode";
                    target = {
                      entity_id = "climate.esphome_web_6c4990_bedroom_mini_split";
                    };
                    data = {
                      hvac_mode = "cool";
                    };
                  }
                  {
                    action = "climate.set_temperature";
                    target = {
                      entity_id = "climate.esphome_web_6c4990_bedroom_mini_split";
                    };
                    data = {
                      temperature = 24;
                    };
                  }
                  {
                    action = "climate.set_fan_mode";
                    target = {
                      entity_id = "climate.esphome_web_6c4990_bedroom_mini_split";
                    };
                    data = {
                      fan_mode = "auto";
                    };
                  }
                ];
              }
              {
                "if" = [
                  {
                    condition = "template";
                    value_template = "{{ bedroom_need == 'fan' }}";
                  }
                ];
                "then" = [
                  {
                    action = "climate.set_hvac_mode";
                    target = {
                      entity_id = "climate.esphome_web_6c4990_bedroom_mini_split";
                    };
                    data = {
                      hvac_mode = "fan_only";
                    };
                  }
                  {
                    action = "climate.set_fan_mode";
                    target = {
                      entity_id = "climate.esphome_web_6c4990_bedroom_mini_split";
                    };
                    data = {
                      fan_mode = "auto";
                    };
                  }
                ];
              }
              # Set office as needed
              {
                "if" = [
                  {
                    condition = "template";
                    value_template = "{{ office_need == 'heat' }}";
                  }
                ];
                "then" = [
                  {
                    action = "climate.set_hvac_mode";
                    target = {
                      entity_id = "climate.esphome_web_6ab408_office_mini_split";
                    };
                    data = {
                      hvac_mode = "heat";
                    };
                  }
                  {
                    action = "climate.set_temperature";
                    target = {
                      entity_id = "climate.esphome_web_6ab408_office_mini_split";
                    };
                    data = {
                      temperature = 22;
                    };
                  }
                  {
                    action = "climate.set_fan_mode";
                    target = {
                      entity_id = "climate.esphome_web_6ab408_office_mini_split";
                    };
                    data = {
                      fan_mode = "auto";
                    };
                  }
                ];
              }
              {
                "if" = [
                  {
                    condition = "template";
                    value_template = "{{ office_need == 'cool' }}";
                  }
                ];
                "then" = [
                  {
                    action = "climate.set_hvac_mode";
                    target = {
                      entity_id = "climate.esphome_web_6ab408_office_mini_split";
                    };
                    data = {
                      hvac_mode = "cool";
                    };
                  }
                  {
                    action = "climate.set_temperature";
                    target = {
                      entity_id = "climate.esphome_web_6ab408_office_mini_split";
                    };
                    data = {
                      temperature = 24;
                    };
                  }
                  {
                    action = "climate.set_fan_mode";
                    target = {
                      entity_id = "climate.esphome_web_6ab408_office_mini_split";
                    };
                    data = {
                      fan_mode = "auto";
                    };
                  }
                ];
              }
              {
                "if" = [
                  {
                    condition = "template";
                    value_template = "{{ office_need == 'fan' }}";
                  }
                ];
                "then" = [
                  {
                    action = "climate.set_hvac_mode";
                    target = {
                      entity_id = "climate.esphome_web_6ab408_office_mini_split";
                    };
                    data = {
                      hvac_mode = "fan_only";
                    };
                  }
                  {
                    action = "climate.set_fan_mode";
                    target = {
                      entity_id = "climate.esphome_web_6ab408_office_mini_split";
                    };
                    data = {
                      fan_mode = "auto";
                    };
                  }
                ];
              }
              # Set downstairs as needed
              {
                "if" = [
                  {
                    condition = "template";
                    value_template = "{{ downstairs_need == 'heat' }}";
                  }
                ];
                "then" = [
                  {
                    action = "climate.set_hvac_mode";
                    target = {
                      entity_id = "climate.esphome_web_6c37b0_downstairs_mini_split";
                    };
                    data = {
                      hvac_mode = "heat";
                    };
                  }
                  {
                    action = "climate.set_temperature";
                    target = {
                      entity_id = "climate.esphome_web_6c37b0_downstairs_mini_split";
                    };
                    data = {
                      temperature = 22;
                    };
                  }
                  {
                    action = "climate.set_fan_mode";
                    target = {
                      entity_id = "climate.esphome_web_6c37b0_downstairs_mini_split";
                    };
                    data = {
                      fan_mode = "auto";
                    };
                  }
                ];
              }
              {
                "if" = [
                  {
                    condition = "template";
                    value_template = "{{ downstairs_need == 'cool' }}";
                  }
                ];
                "then" = [
                  {
                    action = "climate.set_hvac_mode";
                    target = {
                      entity_id = "climate.esphome_web_6c37b0_downstairs_mini_split";
                    };
                    data = {
                      hvac_mode = "cool";
                    };
                  }
                  {
                    action = "climate.set_temperature";
                    target = {
                      entity_id = "climate.esphome_web_6c37b0_downstairs_mini_split";
                    };
                    data = {
                      temperature = 24;
                    };
                  }
                  {
                    action = "climate.set_fan_mode";
                    target = {
                      entity_id = "climate.esphome_web_6c37b0_downstairs_mini_split";
                    };
                    data = {
                      fan_mode = "auto";
                    };
                  }
                ];
              }
              {
                "if" = [
                  {
                    condition = "template";
                    value_template = "{{ downstairs_need == 'fan' }}";
                  }
                ];
                "then" = [
                  {
                    action = "climate.set_hvac_mode";
                    target = {
                      entity_id = "climate.esphome_web_6c37b0_downstairs_mini_split";
                    };
                    data = {
                      hvac_mode = "fan_only";
                    };
                  }
                  {
                    action = "climate.set_fan_mode";
                    target = {
                      entity_id = "climate.esphome_web_6c37b0_downstairs_mini_split";
                    };
                    data = {
                      fan_mode = "auto";
                    };
                  }
                ];
              }
            ];
          }
        ];
      };
    };
  };
}
