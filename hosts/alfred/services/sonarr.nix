{
  services.sonarr = {
    enable = true;
  };

  services.caddy.virtualHosts."alfred.tailnet-0b15.ts.net" = {
    extraConfig = ''
      reverse_proxy /sonarr* http://127.0.0.1:8989
    '';
  };
}
