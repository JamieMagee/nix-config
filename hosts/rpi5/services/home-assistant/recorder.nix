{
  services.home-assistant.config = {
    logger = {
      logs = {
        homeassistant.components.recorder = "debug";
      };
    };
    recorder = {
      exclude = {
        entity_globs = [
          "button.*_switch_*"
          "number.*_switch_*"
          "select.*_switch_*"
          "sensor.*_switch_*"
        ];
      };
    };
  };
}
