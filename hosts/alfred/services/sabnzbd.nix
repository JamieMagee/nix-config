{pkgs, ...}: {
  services.sabnzbd = {
    enable = true;
    package = pkgs.sabnzbd.override {
      par2cmdline = pkgs.par2cmdline-turbo;
    };
  };

  services.caddy.virtualHosts."alfred.tailnet-0b15.ts.net" = {
    extraConfig = ''
      reverse_proxy /sabnzbd* http://[::1]:8080
    '';
  };
}
