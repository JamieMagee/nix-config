{
  services.adguardhome = {
    enable = true;
  };

  networking.firewall = {
    allowedTCPPorts = [
      53
      3000
    ];
    allowedUDPPorts = [
      53
    ];
  };

  services.caddy.virtualHosts."rpi.tailnet-0b15.ts.net" = {
    extraConfig = ''
      handle_path /dns* {
        reverse_proxy http://[::1]:3000
      }

      @dns {
        header Referer https://rpi.tailnet-0b15.ts.net/dns
      }
      reverse_proxy @dns http://[::1]:3000
    '';
  };
}
