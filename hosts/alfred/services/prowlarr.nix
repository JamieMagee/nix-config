{
  services.prowlarr = {
    enable = true;
  };

  services.caddy.virtualHosts."alfred.tailnet-0b15.ts.net" = {
    extraConfig = ''
      reverse_proxy /prowlarr* http://[::1]:9696
    '';
  };

  # Prowlarr runs with systemd DynamicUser-style state: real state
  # lives under /var/lib/private/<service> and /var/lib/prowlarr is
  # a symlink into it.
  environment.persistence."/persist".directories = [
    "/var/lib/private/prowlarr"
  ];
}
