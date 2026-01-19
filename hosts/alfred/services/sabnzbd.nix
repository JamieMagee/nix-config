{
  services.sabnzbd = {
    enable = true;
    secretFiles = [ "/var/lib/sabnzbd/secrets.ini" ];
    settings = {
      misc = {
        complete_dir = "/mnt/downloads/complete";
        download_dir = "/mnt/downloads/incomplete";
        permissions = "0770";
        host = "::1";
        port = 8080;
        url_base = "/sabnzbd";
        host_whitelist = "alfred.tailnet-0b15.ts.net";
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
}
