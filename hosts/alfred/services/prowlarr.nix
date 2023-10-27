{
  services.prowlarr = {
    enable = true;
  };

  services.caddy.virtualHosts."alfred.tailnet-0b15.ts.net" = {
    extraConfig = ''
      reverse_proxy /prowlarr* http://127.0.0.1:9696
    '';
  };
}
