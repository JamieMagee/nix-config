{ pkgs, ... }:
{
  services.sabnzbd = {
    enable = true;
  };

  services.caddy.virtualHosts."alfred.tailnet-0b15.ts.net" = {
    extraConfig = ''
      reverse_proxy /sabnzbd* http://[::1]:8080
    '';
  };
}
