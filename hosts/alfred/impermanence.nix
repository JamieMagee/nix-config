{
  lib,
  pkgs,
  inputs,
  ...
}:
{
  imports = [ inputs.impermanence.nixosModules.impermanence ];

  fileSystems."/".neededForBoot = lib.mkDefault true;
  fileSystems."/persist".neededForBoot = lib.mkDefault true;

  # systemd's DynamicUser= / StateDirectory= setup refuses to start a
  # service (exit 238 STATE_DIRECTORY) if /var/lib/private is not
  # mode 0700 root:root. impermanence's parent-directory creation
  # makes it 0755 by default, so re-assert the correct mode every
  # boot — otherwise services like prowlarr fail after a rollback.
  systemd.tmpfiles.rules = [
    "d /var/lib/private 0700 root root - -"
  ];

  environment.persistence."/persist" = {
    hideMounts = true;

    directories = [
      # Core system state
      "/var/log"
      "/var/lib/nixos" # UID/GID allocation table — critical
      "/var/lib/systemd" # timer state, coredumps, random-seed, etc.
      "/var/lib/fwupd"

      # Networking
      "/var/lib/NetworkManager"
      "/etc/NetworkManager/system-connections"
      "/var/lib/tailscale"

      # Media services
      "/var/lib/plex"
      "/var/lib/sonarr"
      "/var/lib/radarr"
      "/var/lib/sabnzbd"
      # Prowlarr runs with systemd DynamicUser-style state: real state
      # lives under /var/lib/private/<service> and /var/lib/prowlarr is
      # a symlink into it.
      "/var/lib/private/prowlarr"
      # Tautulli's NixOS module on this host uses /var/lib/plexpy
      # (PlexPy is the upstream project name).
      "/var/lib/plexpy"
      "/var/lib/caddy"
      "/var/lib/recyclarr"

      # SABnzbd download staging.
      # NOTE: /mnt/downloads currently lives on the root (zroot/root)
      # dataset, not on `tank`. With rollback armed, anything here
      # would be wiped on reboot, so it must be persisted. Long-term,
      # consider relocating downloads to the tank pool (e.g. add a
      # tank/downloads dataset and point SABnzbd at it) and dropping
      # this entry.
      "/mnt/downloads"

      # root user home — /root is on the root dataset and would be
      # wiped on rollback. Persist shell history, SSH known_hosts, etc.
      "/root"
    ];

    files = [
      "/etc/machine-id"
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_ed25519_key.pub"
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_rsa_key.pub"
    ];
  };

  # The rollback unit only makes sense in a systemd initrd. Force it
  # on rather than relying on the nixpkgs default; if a future change
  # disables it, the rebuild should fail loudly.
  boot.initrd.systemd.enable = lib.mkForce true;

  boot.initrd.systemd.services.rollback-root = {
    description = "Rollback ZFS root dataset to blank snapshot";
    wantedBy = [ "initrd.target" ];
    # Fail-closed: if rollback fails, sysroot.mount fails too and the
    # system refuses to boot with a dirty root rather than silently
    # continuing.
    requiredBy = [ "sysroot.mount" ];
    requires = [ "zfs-import-zroot.service" ];
    after = [ "zfs-import-zroot.service" ];
    before = [ "sysroot.mount" ];
    unitConfig.DefaultDependencies = "no";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.zfs}/bin/zfs rollback -r zroot/root@blank";
    };
  };
}

