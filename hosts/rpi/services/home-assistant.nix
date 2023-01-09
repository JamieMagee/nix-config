{
  services.home-assistant = {
    enable = true;
    config = {
      default_config = {};
      extraComponents = [
        "met"
        "radio_browser"
      ];
      http = {
        trusted_proxies = [
          "127.0.0.1"
          "::1"
        ];
        use_x_forwarded_for = true;
      };
    };
  };

  services.caddy.virtualHosts."rpi.tailnet-0b15.ts.net" = {
    extraConfig = ''
      reverse_proxy http://[::1]:8123
    '';
  };
}
