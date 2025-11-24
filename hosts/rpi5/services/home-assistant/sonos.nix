{
  services.home-assistant = {
    extraComponents = [ "sonos" ];
  };

  networking.firewall.allowedTCPPorts = [
    1400
    8123
  ];
}
