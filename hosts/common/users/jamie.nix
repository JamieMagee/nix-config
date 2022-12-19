{
  pkgs,
  config,
  ...
}: {
  users.users.jamie = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = [
      "wheel"
      "networkmanager"
      "video"
      "docker"
    ];
  };
}
