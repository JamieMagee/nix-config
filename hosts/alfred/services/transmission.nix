{
  services.transmission = {
    enable = true;
    settings = {
      rpc-host-whitelist = "alfred.tailnet-0b15.ts.net";
    };
  };

  services.caddy.virtualHosts."alfred.tailnet-0b15.ts.net" = {
    extraConfig = ''
      reverse_proxy /transmission* http://[::1]:9091
    '';
  };
}
