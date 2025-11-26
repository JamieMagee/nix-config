{ config, ... }:
let
  commonHeaders = ''
    header X-Content-Type-Options nosniff
    header X-Frame-Options SAMEORIGIN
    header -Server
  '';
in
{
  services.caddy = {
    enable = true;

    # Tailscale (HTTPS with automatic certs)
    virtualHosts."alfred.tailnet-0b15.ts.net".extraConfig = commonHeaders;

    # Local network (HTTP only)
    virtualHosts."http://alfred.localdomain".extraConfig = commonHeaders;
  };

  # Tailscale interface
  networking.firewall.interfaces.tailscale0 = {
    allowedTCPPorts = [
      80
      443
    ];
    allowedUDPPorts = [
      80
      443
    ];
  };

  # Local network - HTTP only
  networking.firewall.allowedTCPPorts = [ 80 ];

  services.tailscale.permitCertUid = config.services.caddy.user;
}
