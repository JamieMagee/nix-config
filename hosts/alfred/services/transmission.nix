{
  services.transmission = {
    enable = true;
    settings = {
      rpc-host-whitelist = "alfred.tailnet-0b15.ts.net";
    };
  };

  networking.firewall.interfaces.tailscale0.allowedTCPPorts = [9091];

  services.caddy.virtualHosts."alfred.tailnet-0b15.ts.net" = {
    extraConfig = ''
      reverse_proxy /transmission* http://127.0.0.1:9091
    '';
  };
}
