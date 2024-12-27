{ lib, ... }:
{
  services.adguardhome = {
    enable = true;
    settings = {
      http = {
        address = "0.0.0.0:3000";
      };
      dns = {
        bind_hosts = [
          "0.0.0.0"
        ];
        port = 53;
        ratelimit = 0;
        upstream_dns = [
          "h3://security.cloudflare-dns.com/dns-query"
          "https://dns11.quad9.net/dns-query"
        ];
        bootstrap_dns = [
          "9.9.9.11"
          "149.112.112.11"
          "2620:fe::11"
          "2620:fe::fe:11"
          "1.1.1.2"
          "1.0.0.2"
          "2606:4700:4700::1112"
          "2606:4700:4700::1002"
        ];
        local_ptr_upstreams = [
          "192.168.1.1"
          "100.100.100.100"
        ];
      };
      filters =
        let
          mkFilter =
            idx:
            { name, url }:
            {
              inherit name url;
              enabled = true;
              id = idx;
            };

          filterDefs = [
            {
              name = "hagezi pro plus";
              url = "https://raw.githubusercontent.com/hagezi/dns-blocklists/main/adblock/pro.plus.txt";
            }
            {
              name = "hagezi threat intelligence";
              url = "https://raw.githubusercontent.com/hagezi/dns-blocklists/main/adblock/tif.txt";
            }
            {
              name = "hagezi microsoft";
              url = "https://raw.githubusercontent.com/hagezi/dns-blocklists/main/adblock/native.winoffice.txt";
            }
            {
              name = "hagezi LG";
              url = "https://raw.githubusercontent.com/hagezi/dns-blocklists/main/adblock/native.lgwebos.txt";
            }
          ];
        in
        lib.imap1 mkFilter filterDefs;
    };
  };

  networking.firewall = {
    allowedTCPPorts = [
      53
      853
    ];
    allowedUDPPorts = [
      53
      853
    ];
  };

  services.caddy.virtualHosts."rpi5.tailnet-0b15.ts.net" = {
    extraConfig = ''
      handle_path /dns* {
        reverse_proxy http://[::1]:3000
      }

      @dns {
        header Referer https://rpi5.tailnet-0b15.ts.net/dns
      }
      reverse_proxy @dns http://[::1]:3000
    '';
  };
}
