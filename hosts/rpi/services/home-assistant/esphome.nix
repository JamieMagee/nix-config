{
  services.home-assistant = {
    extraComponents = [
      "esphome"
    ];
  };

  services.esphome = {
    enable = true;
  };

  services.caddy.virtualHosts."alfred.tailnet-0b15.ts.net" = {
    extraConfig = ''
      reverse_proxy /esphome* http://[::1]:6052
    '';
  };
}
