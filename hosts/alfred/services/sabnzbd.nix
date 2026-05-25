{
  services.sabnzbd = {
    enable = true;
    group = "services";
    secretFiles = [ "/var/lib/sabnzbd/secrets.ini" ];
    allowConfigWrite = true;
    settings = {
      misc = {
        complete_dir = "/mnt/downloads/complete";
        download_dir = "/mnt/downloads/incomplete";
        permissions = "0770";
        host = "::1";
        port = 8080;
        url_base = "/sabnzbd";
        host_whitelist = "alfred.tailnet-0b15.ts.net";
        local_ranges = "100.64.0.0/10,192.168.0.0/16";
      };
      servers."news.eweka.nl" = {
        displayname = "Eweka";
        name = "news.eweka.nl";
        host = "news.eweka.nl";
        port = 443;
        connections = 50;
        use_ssl = true;
        ssl_verify = "strict";
      };
    };
  };

  services.caddy.virtualHosts."alfred.tailnet-0b15.ts.net" = {
    extraConfig = ''
      reverse_proxy /sabnzbd* http://[::1]:8080
    '';
  };

  environment.persistence."/persist".directories = [
    "/var/lib/sabnzbd"

    # SABnzbd download staging.
    # NOTE: /mnt/downloads currently lives on the root (zroot/root)
    # dataset, not on `tank`. With rollback armed, anything here
    # would be wiped on reboot, so it must be persisted. Long-term,
    # consider relocating downloads to the tank pool (e.g. add a
    # tank/downloads dataset and point SABnzbd at it) and dropping
    # this entry.
    "/mnt/downloads"
  ];
}
