{
  services.tautulli = {
    enable = true;
  };

  services.caddy.virtualHosts."alfred.tailnet-0b15.ts.net" = {
    extraConfig = ''
      reverse_proxy /tautulli* http://127.0.0.1:8181
    '';
  };

  services.caddy.virtualHosts."http://alfred.localdomain" = {
    extraConfig = ''
      reverse_proxy /tautulli* http://127.0.0.1:8181
    '';
  };
}
