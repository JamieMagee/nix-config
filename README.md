[![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/JamieMagee/nix-config/build.yml?branch=main&style=for-the-badge)](https://github.com/JamieMagee/nix-config/actions/workflows/build.yml?query=branch%3Amain)
[![Built with nix](https://img.shields.io/static/v1?logo=nixos&logoColor=white&label=&message=Built%20with%20Nix&color=41439a&style=for-the-badge)](https://builtwithnix.org/)

# NixOS Configuration

This repository contains my personal NixOS and Home Manager configurations, managing multiple machines and user environments declaratively using Nix flakes.

## Hosts

This configuration manages several different machines:

- [**alfred**](./hosts/alfred/README.md) - x86_64 server running media services
- **jamie-desktop** - Main desktop PC with AMD CPU/GPU, gaming setup, development tools
- [**oci-vm**](./hosts/oci-vm/README.md) - Oracle Cloud Infrastructure ARM64 virtual machine
- [**rpi5**](./hosts/rpi5/README.md) - Raspberry Pi 5 running Home Assistant and network services

## Structure

```
├── flake.nix           # Main flake configuration
├── hosts/              # NixOS system configurations
│   ├── alfred/         # Media server
│   ├── jamie-desktop/  # Main desktop
│   ├── oci-vm/         # Oracle Cloud Infrastructure VM
│   ├── rpi5/           # Raspberry Pi with services
│   └── common/         # Shared system modules
├── home/               # Home Manager configurations
│   └── jamie/          # User-specific configs
└── modules/            # Custom NixOS and Home Manager modules
```

## Usage

Build and switch to a configuration:

```bash
sudo nixos-rebuild switch --flake .#hostname
```

Apply Home Manager configuration:

```bash
home-manager switch --flake .#username@hostname
```

Deploy to remote systems:

```bash
nix run github:serokell/deploy-rs .#hostname
```
