# Alfred — Impermanence Deployment Guide

This guide migrates `alfred` to a [nix-community/impermanence][impermanence]
setup with an **ephemeral root** (`/`) and a **persistent `/persist`
volume** holding only the state we explicitly enumerate, using ZFS
rollback to a blank snapshot at every boot.

The migration is done **in-place on the running NAS** — no reformat, no
reinstall.

> [!IMPORTANT]
> Run every step in this guide as root (`sudo -i`) on the alfred console
> or over an SSH session with a stable connection.  Several steps stop
> services and move state; an interrupted move is recoverable but
> annoying.
>
> The `tank` RAIDZ pool (media library at `/mnt/data`) is independent of
> the root pool throughout this migration and is **never** touched.

## Overview

The work is gated behind two NixOS options defined in
`hosts/alfred/impermanence.nix`:

| Option | Default | Effect when `true` |
| --- | --- | --- |
| `alfred.impermanence.enablePersistence` | `false` | `/persist` is treated as the source of persistent state; declared paths are bind-mounted into the live root. |
| `alfred.impermanence.armRollback` | `false` | The initrd rolls `/` back to `zroot/root@blank` at every boot, making `/` ephemeral. |

You flip them on in order as each phase of the migration is verified.

## Pre-flight checks

Run these on `alfred` before you start:

```bash
# Confirm the zroot pool exists and is healthy
zpool status zroot

# Confirm root is on zroot/root (and there's no existing zroot/persist
# from a previous attempt)
zfs list -r zroot

# Confirm boot uses systemd-boot, EFI vars writable
bootctl status

# Check which services are running so you have a baseline
systemctl list-units --type=service --state=running | grep -E \
    'plex|sonarr|radarr|sabnzbd|prowlarr|tautulli|caddy|recyclarr|tailscale|networkmanager'

# Verify the *real* state paths used by services that may surprise you.
# Tautulli historically lives at /var/lib/plexpy; newer modules use
# /var/lib/tautulli. One of these will exist on this host:
ls -ld /var/lib/plexpy /var/lib/tautulli 2>/dev/null

# Prowlarr uses DynamicUser=true; the real state lives under
# /var/lib/private/prowlarr:
ls -ld /var/lib/prowlarr /var/lib/private/prowlarr 2>/dev/null

# Confirm SABnzbd's download dir lives where the config says
ls -ld /mnt/downloads/incomplete /mnt/downloads/complete 2>/dev/null
```

## Phase 1 — Land the module, no behavior change

> Branch: `alfred/impermanence`. After review, merge to `main`. This
> phase introduces the impermanence input, the `persist` dataset entry
> in `disko.nix`, and the new `impermanence.nix` module — all with the
> gates **off**.

```bash
cd /home/jamie/src/code/nix-config
git pull
sudo nixos-rebuild switch --flake .#alfred
```

The rebuild adds the impermanence module to the store and adds a
`fileSystems."/persist"` entry to `/etc/fstab`, but `neededForBoot` is
not set, persistence is disabled, and rollback is disabled. The mount
attempt for `/persist` will warn because the ZFS dataset does not exist
yet — this is expected and harmless.

> [!NOTE]
> If the warning concerns you, you can skip the rebuild here and go
> straight to Phase 2; the dataset only needs to exist before
> `enablePersistence` flips to `true` in Phase 3.

## Phase 2 — Create the persist dataset

```bash
# Create the dataset and mount it.
sudo zfs create zroot/persist

# Verify it mounted at /persist
findmnt /persist
zfs get mountpoint zroot/persist
```

`zroot/persist` inherits `atime=off` and `compression=zstd` from the
pool's `rootFsOptions`.

## Phase 3 — Migrate state into `/persist`

The goal is to copy every directory in the persistence list into
`/persist/...` **before** enabling the bind mounts. For service state,
stop the service first so the copy captures a consistent snapshot.

> [!IMPORTANT]
> Use `rsync -aHAX` (copy with hardlinks, ACLs, xattrs preserved), then
> verify, then enable the bind mount, then remove the original copy.
> Do **not** `mv` — a failed move on a live system can leave services
> in a half-state.

### 3a. System state (no services to stop)

```bash
sudo mkdir -p /persist/var/{log,lib}
sudo rsync -aHAX /var/log/        /persist/var/log/
sudo rsync -aHAX /var/lib/nixos/  /persist/var/lib/nixos/
sudo rsync -aHAX /var/lib/systemd/ /persist/var/lib/systemd/
sudo rsync -aHAX /var/lib/fwupd/   /persist/var/lib/fwupd/
```

### 3b. Networking state

```bash
sudo rsync -aHAX /var/lib/NetworkManager/ \
    /persist/var/lib/NetworkManager/
sudo mkdir -p /persist/etc/NetworkManager/system-connections
sudo rsync -aHAX /etc/NetworkManager/system-connections/ \
    /persist/etc/NetworkManager/system-connections/
sudo rsync -aHAX /var/lib/tailscale/ /persist/var/lib/tailscale/
```

### 3c. Media services

For each service, stop it, copy state, leave it stopped until Phase 4.

```bash
for svc in plex sonarr radarr sabnzbd prowlarr tautulli caddy recyclarr; do
    sudo systemctl stop "$svc" 2>/dev/null || true
done

sudo rsync -aHAX /var/lib/plex/      /persist/var/lib/plex/
sudo rsync -aHAX /var/lib/sonarr/    /persist/var/lib/sonarr/
sudo rsync -aHAX /var/lib/radarr/    /persist/var/lib/radarr/
sudo rsync -aHAX /var/lib/sabnzbd/   /persist/var/lib/sabnzbd/
sudo rsync -aHAX /var/lib/caddy/     /persist/var/lib/caddy/
sudo rsync -aHAX /var/lib/recyclarr/ /persist/var/lib/recyclarr/ \
    2>/dev/null || true

# Prowlarr — copy the real DynamicUser state directory.
sudo mkdir -p /persist/var/lib/private
sudo rsync -aHAX /var/lib/private/prowlarr/ \
    /persist/var/lib/private/prowlarr/

# Tautulli — copy whichever of plexpy / tautulli actually exists.
[ -d /var/lib/plexpy ]   && sudo rsync -aHAX /var/lib/plexpy/ \
    /persist/var/lib/plexpy/
[ -d /var/lib/tautulli ] && sudo rsync -aHAX /var/lib/tautulli/ \
    /persist/var/lib/tautulli/
```

### 3d. SABnzbd download staging

`/mnt/downloads` currently lives on the root dataset. With rollback
armed, anything here gets wiped on every reboot, so it has to be
persisted.

```bash
sudo rsync -aHAX /mnt/downloads/ /persist/mnt/downloads/
```

> [!NOTE]
> Long-term, downloads belong on `tank` rather than the small NVMe.
> A clean follow-up is to create a `tank/downloads` dataset, point
> SABnzbd at `/mnt/data/downloads/{incomplete,complete}`, and remove
> the `/mnt/downloads` entry from `environment.persistence`. That work
> is **out of scope** for this migration.

### 3e. Root user home, machine-id, SSH host keys

```bash
sudo rsync -aHAX /root/ /persist/root/

sudo mkdir -p /persist/etc/ssh
sudo cp -a /etc/machine-id           /persist/etc/machine-id
sudo cp -a /etc/ssh/ssh_host_*       /persist/etc/ssh/
```

## Phase 4 — Enable persistence (bind mounts on, rollback still off)

Edit `hosts/alfred/default.nix`:

```nix
  alfred.impermanence = {
    enablePersistence = true;   # ← flip this
    armRollback = false;
  };
```

Commit, deploy:

```bash
git add hosts/alfred/default.nix
git commit -m "alfred: enable impermanence persistence (no rollback yet)"
git push
sudo nixos-rebuild switch --flake .#alfred
```

The rebuild will:

- Mark `/` and `/persist` with `neededForBoot = true`.
- Generate `systemd.mounts` units that bind-mount every entry in the
  persistence list from `/persist/...` over the live tree.
- Auto-suppress `systemd-machine-id-commit.service` because
  `/etc/machine-id` is now bind-mounted.

Verify each service comes back up reading its persisted state:

```bash
for svc in plex sonarr radarr sabnzbd prowlarr tautulli caddy recyclarr \
           tailscaled NetworkManager; do
    systemctl start "$svc" 2>/dev/null
    sleep 1
    systemctl is-active "$svc" 2>/dev/null \
        && echo "$svc: ok" || echo "$svc: NOT RUNNING"
done

# Sanity-check Plex's library is intact, Sonarr/Radarr show your
# existing series/movies, SABnzbd shows your queue, etc.
```

Then **reboot** to confirm the bind mounts come up cleanly without any
rollback in the picture:

```bash
sudo reboot
```

After the reboot, re-run the service checks above and confirm every
service is in the state it was before the migration.

> [!WARNING]
> If anything is missing or empty after this reboot, **do not arm
> rollback**. The persistence list is the only thing protecting state
> when rollback is on. Fix the list (add missing paths, re-rsync) and
> reboot again until everything is clean.

## Phase 5 — Clean root, snapshot `@blank`

Now that bind mounts are masking all the real state, clean transient
junk from `/` so the snapshot is as small and clean as possible.

```bash
sudo rm -rf /tmp/* /var/tmp/*

# Optional: drop /root caches (the persisted /root will be restored
# from /persist via the bind mount anyway).
sudo rm -rf /root/.cache
```

Take the rollback target snapshot:

```bash
sudo zfs snapshot zroot/root@blank
zfs list -t snapshot zroot/root
```

This snapshot captures `/` as it is **right now**: containing only
directory skeletons, NixOS-managed symlinks, and the bind mount points.
The next boot, when rollback is armed, the initrd will roll back to
exactly this state.

## Phase 6 — Arm rollback

Edit `hosts/alfred/default.nix`:

```nix
  alfred.impermanence = {
    enablePersistence = true;
    armRollback = true;        # ← flip this
  };
```

Commit, deploy:

```bash
git add hosts/alfred/default.nix
git commit -m "alfred: arm impermanence ZFS rollback"
git push
sudo nixos-rebuild boot --flake .#alfred
```

> [!NOTE]
> Use `nixos-rebuild boot` (not `switch`) for this step. The rollback
> service runs in the initrd; it does not take effect on the running
> system, only at the next boot. `boot` writes the new generation
> without trying to activate it live.

Now reboot:

```bash
sudo reboot
```

On the next boot the initrd will run `zfs rollback -r zroot/root@blank`
**before** `sysroot.mount` (it's `requiredBy = ["sysroot.mount"]`), so
boot fails closed if rollback fails. After boot:

```bash
# Should show only directory skeletons, no stale state on /
ls /
ls /var/lib                # mostly bind mounts
zfs list -t snapshot       # @blank still present

# Services should still be healthy
systemctl --failed
```

## Phase 7 — Ongoing operations

### Adding new persisted paths

Edit the `directories` or `files` list in
`hosts/alfred/impermanence.nix`. Before rebuilding, copy any existing
state into `/persist/...` so the bind mount has something to expose:

```bash
sudo rsync -aHAX /var/lib/newservice/ /persist/var/lib/newservice/
sudo nixos-rebuild switch --flake .#alfred
```

### Refreshing `@blank`

If you legitimately want the rollback target to include changes (e.g.
NixOS activation added a new directory under `/` that you want present
on every boot), the cycle is:

```bash
# Either reboot once (so root is freshly rolled back), or live in your
# current dirty root if you prefer.
sudo zfs destroy zroot/root@blank
sudo zfs snapshot zroot/root@blank
```

> [!CAUTION]
> `zfs rollback -r` **destroys any snapshots of `zroot/root` newer than
> `@blank`**. If you ever start using `zfs snapshot` for root backups,
> set up a different scheme (e.g. snapshot `zroot/persist` instead, or
> use `zfs-auto-snapshot` only on `/persist`).

### Disarming temporarily

If you need to boot once without rollback (rescue mode):

```nix
  alfred.impermanence.armRollback = false;
```

`nixos-rebuild boot`, reboot. `/` is now whatever happens to be in the
`zroot/root` dataset right now (typically the contents of `@blank` from
the previous boot's rollback). Fix what you need, refresh `@blank` per
above, set `armRollback = true` again, rebuild, reboot.

## Recovery — if something goes wrong

### "The boot is stuck in the initrd"

The rollback unit is fail-closed, so if rollback fails the system
refuses to mount sysroot. Boot the previous (pre-impermanence) NixOS
generation from the systemd-boot menu and diagnose from there:

```bash
sudo journalctl -b -1   # logs from the failed boot
zpool status            # is the pool healthy?
zfs list -t snapshot zroot/root  # does @blank still exist?
```

If `@blank` was destroyed somehow, recreate it from the current root
state and try again (Phase 5).

### "A service started with no data after enabling persistence"

Almost always: the persistence path doesn't match where the service
actually stores state on this host. Stop the service, examine where it
wrote its empty state, and either:

- Add that path to the persistence list and re-copy from the original
  data (if you saved it), or
- Unmount the bind mount, `mv` the empty state out of the way, restore
  the original, fix the path, rebuild.

If the original data is hidden behind a bind mount but not deleted,
unmount it to see:

```bash
sudo umount /var/lib/<svc>
ls /var/lib/<svc>          # original data, if it survived
```

## Reference

- Impermanence module: <https://github.com/nix-community/impermanence>
- The full research report (including alternatives, gotchas, and `rpi5`
  feasibility) is in the session archive — see project memory.
- Module definition: [`hosts/alfred/impermanence.nix`](./impermanence.nix)
- Disko layout: [`hosts/alfred/disko.nix`](./disko.nix)
- Host config: [`hosts/alfred/default.nix`](./default.nix)

[impermanence]: https://github.com/nix-community/impermanence
