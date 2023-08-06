{
  services.home-assistant = {
    extraComponents = [
      "sonos"
    ];
    config = {
      sonos = {
        media_player = {
          hosts = [
            "192.168.1.246"
          ];
        };
      };
    };
  };

  networking.firewall.allowedTCPPorts = [
    1400
  ];
}
