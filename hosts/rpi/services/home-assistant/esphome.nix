{
  services.home-assistant = {
    extraComponents = [
      "esphome"
    ];
  };

  services.esphome = {
    enable = true;
    openFirewall = true;
    address = "0.0.0.0";
  };
}
