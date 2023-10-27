{config, ...}: {
  services.caddy = {
    enable = true;
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
