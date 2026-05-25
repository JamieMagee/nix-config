{
  services.radarr = {
    enable = true;
    group = "services";
  };

  services.caddy.virtualHosts."alfred.tailnet-0b15.ts.net" = {
    extraConfig = ''
      reverse_proxy /radarr* http://[::1]:7878
    '';
  };

  environment.persistence."/persist".directories = [
    "/var/lib/radarr"
  ];
}
