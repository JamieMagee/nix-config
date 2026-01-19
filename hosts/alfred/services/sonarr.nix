{
  services.sonarr = {
    enable = true;
    group = "services";
  };

  services.caddy.virtualHosts."alfred.tailnet-0b15.ts.net" = {
    extraConfig = ''
      reverse_proxy /sonarr* http://[::1]:8989
    '';
  };
}
