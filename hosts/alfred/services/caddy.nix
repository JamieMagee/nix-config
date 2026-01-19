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

  services.tailscale.permitCertUid = config.services.caddy.user;
}
