{
  services = {
    home-assistant = {
      extraComponents = [ "esphome" ];
    };
    esphome = {
      enable = true;
      openFirewall = true;
      address = "0.0.0.0";
      allowedDevices = [ "char-ttyS" ];
    };
  };
}
