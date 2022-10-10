{ config, ... }: {
  services.caddy = {
    enable = true;
    email = "jamie.magee@gmail.com";
  };

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];

  services.tailscale.permitCertUid = config.services.caddy.user;
}
