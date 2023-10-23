{
  services.prowlarr = {
    enable = true;
  };

  networking.firewall.interfaces.tailscale0.allowedTCPPorts = [9696];

  services.caddy.virtualHosts."alfred.tailnet-0b15.ts.net" = {
    extraConfig = ''
      reverse_proxy /prowlarr* http://127.0.0.1:9696
    '';
  };
}
