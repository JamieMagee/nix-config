{
  services.tautulli = {
    enable = true;
  };

  services.caddy.virtualHosts."alfred.tailnet-0b15.ts.net" = {
    extraConfig = ''
      reverse_proxy /tautulli* http://127.0.0.1:8181
    '';
  };

  # Tautulli's NixOS module on this host uses /var/lib/plexpy
  # (PlexPy is the upstream project name).
  environment.persistence."/persist".directories = [
    "/var/lib/plexpy"
  ];
}
