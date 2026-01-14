{
  services.sabnzbd = {
    enable = true;
    allowConfigWrite = true;
    secretFiles = [ "/var/lib/sabnzbd/secrets.ini" ];
    settings = {
      misc = {
        complete_dir = "/mnt/downloads/complete";
        incomplete_dir = "/mnt/downloads/incomplete";
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
      reverse_proxy /sabnzbd* http://127.0.0.1:8080
    '';
  };

  services.caddy.virtualHosts."http://alfred.localdomain" = {
    extraConfig = ''
      reverse_proxy /sabnzbd* http://127.0.0.1:8080
    '';
  };
}
