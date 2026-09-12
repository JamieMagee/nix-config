{ config, lib, ... }:
{
  services.podman = {
    enable = true;
  };

  systemd.user = {
    services.podman-prune = {
      Unit = {
        Description = "Prune Podman resources";
      };

      Service = {
        Type = "oneshot";
        ExecStart = "${lib.getExe config.services.podman.package} system prune --all --volumes --force";
      };
    };

    timers.podman-prune = {
      Unit.Description = "Prune Podman resources";
      Timer = {
        OnCalendar = "weekly";
        Persistent = true;
        RandomizedDelaySec = 1800;
      };
      Install.WantedBy = [ "timers.target" ];
    };
  };
}
