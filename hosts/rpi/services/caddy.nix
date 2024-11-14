{ config, ... }:
{
  services.caddy = {
    enable = true;
    virtualHosts."rpi.tailnet-0b15.ts.net".extraConfig = ''
      header X-Content-Type-Options nosniff
      header X-Frame-Options SAMEORIGIN
      header -Server
    '';
  };

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
