{
  services.home-assistant = {
    extraComponents = [
      "esphome"
    ];
  };

  services.esphome = {
    enable = true;
  };
}
