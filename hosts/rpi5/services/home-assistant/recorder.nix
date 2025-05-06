{
  services.home-assistant.config.recorder = {
    exclude = {
      entity_globs = [
        "button.*_switch_*"
        "number.*_switch_*"
        "select.*_switch_*"
        "sensor.*_switch_*"
      ];
    };
  };
}
