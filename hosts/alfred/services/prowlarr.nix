{
  services.prowlarr = {
    enable = true;
  };

  services.caddy.virtualHosts."alfred.tailnet-0b15.ts.net" = {
    extraConfig = ''
      reverse_proxy /prowlarr* http://[::1]:9696
    '';
  };
}
