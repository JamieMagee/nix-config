{
  services.adguardhome = {
    enable = true;
  };

  networking.firewall = {
    allowedTCPPorts = [
      53
    ];
    allowedUDPPorts = [
      53
    ];
  };

  services.caddy.virtualHosts."rpi.tailnet-0b15.ts.net" = {
    extraConfig = ''
      reverse_proxy http://localhost:3000
    '';
  };
}
