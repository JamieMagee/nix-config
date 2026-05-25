{
  services.plex = {
    enable = true;
    group = "services";
    openFirewall = true;
  };

  environment.persistence."/persist".directories = [
    "/var/lib/plex"
  ];
}
