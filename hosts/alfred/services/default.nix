{config, ...}: {
  imports = [
    ./caddy.nix
    ./hd-idle.nix
    ./plex.nix
    ./prowlarr.nix
    ./radarr.nix
    ./sabnzbd.nix
    ./sonarr.nix
    ./transmission.nix
  ];

  users.groups.services.members = with config.services; [
    sabnzbd.user
    sonarr.user
    radarr.user
    plex.user
  ];

  systemd.tmpfiles.rules = [
    "d /mnt/downloads/incomplete 0770 ${config.users.users.jamie.name} ${config.users.groups.services.name}"
    "d /mnt/downloads/complete 0770 ${config.users.users.jamie.name} ${config.users.groups.services.name}"

    "d /mnt/data/tv 0770 ${config.users.users.jamie.name} ${config.users.groups.services.name}"
    "d /mnt/data/movies 0770 ${config.users.users.jamie.name} ${config.users.groups.services.name}"
  ];
}
