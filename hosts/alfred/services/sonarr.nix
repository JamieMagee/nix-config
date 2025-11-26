{
  services.sonarr = {
    enable = true;
  };

  services.caddy.virtualHosts."alfred.tailnet-0b15.ts.net" = {
    extraConfig = ''
      reverse_proxy /sonarr* http://[::1]:8989
    '';
  };

  services.caddy.virtualHosts."http://alfred.localdomain" = {
    extraConfig = ''
      reverse_proxy /sonarr* http://[::1]:8989
    '';
  };
}
