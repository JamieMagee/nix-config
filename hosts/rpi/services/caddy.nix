{ config, ... }: {
  services.caddy = {
    enable = true;
  };

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];

  services.tailscale.permitCertUid = config.services.caddy.user;
}
