[![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/JamieMagee/nix-config/build.yml?branch=main&style=for-the-badge)](https://github.com/JamieMagee/nix-config/actions/workflows/build.yml?query=branch%3Amain)
[![Built with nix](https://img.shields.io/static/v1?logo=nixos&logoColor=white&label=&message=Built%20with%20Nix&color=41439a&style=for-the-badge)](https://builtwithnix.org/)

# nix-config

My NixOS and Home Manager configs. Everything is a Nix flake.

## Hosts

- [alfred](./hosts/alfred/README.md) -- x86_64 NAS, media services (Plex, Sonarr, Radarr, etc.)
- jamie-desktop -- main desktop, AMD CPU/GPU, KDE Plasma, gaming
- [jamie-hyperv](./docs/HYPERV.md) -- Hyper-V Generation 2 VM, KDE Plasma, dev tools
- [oci-vm](./hosts/oci-vm/README.md) -- Oracle Cloud ARM64 VM
- rpi5 -- Raspberry Pi 5, Home Assistant, AdGuard, Caddy

There are also standalone Home Manager configs for WSL machines. See [docs/WSL.md](./docs/WSL.md).

## Structure

```
flake.nix               -- entry point
hosts/
  alfred/               -- NAS / media server
  jamie-desktop/        -- main desktop
  jamie-hyperv/         -- Hyper-V VM
  oci-vm/               -- Oracle Cloud VM
  rpi5/                 -- Raspberry Pi 5
  common/               -- shared NixOS modules
home/
  jamie/                -- Home Manager user configs
modules/                -- custom NixOS and Home Manager modules
```

## Usage

Build and switch on the local machine:

```bash
sudo nixos-rebuild switch --flake .#hostname
```

Apply Home Manager standalone:

```bash
home-manager switch --flake .#username@hostname
```

Deploy to a remote host:

```bash
nix run github:serokell/deploy-rs .#hostname
```

Build a Hyper-V VHDX image you can import directly (works from any machine with Nix):

```bash
nix build .#nixosConfigurations.jamie-hyperv.config.system.build.images.hyperv
```
