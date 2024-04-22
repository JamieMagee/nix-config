{
  virtualisation.docker = {
    enable = true;
  };

  users.users.jamie.extraGroups = [ "docker" ];
}
