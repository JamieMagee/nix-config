# RPi5

RPi5 is a Raspberry Pi 5 server running NixOS with Home Assistant and other services.

## Installation

### Prerequisites

The first part of the installation is to flash a microSD card with a NixOS installer image for Raspberry Pi 5.

Download and flash the installer image:

```bash
# Download the installer image
nix build github:nvmd/nixos-raspberrypi#installerImages.rpi5

# Flash to microSD card (replace /dev/sdX with your actual device)
sudo dd if=result/sd-image/nixos-installer-rpi5-kernelboot-*.img of=/dev/sdX bs=1M status=progress
```

### First boot

Insert the microSD card into your Raspberry Pi 5 and power it on.

> [!IMPORTANT]
> The installer will automatically log you in as the `nixos` user.
> You can become root with `sudo -i` if needed.

### Network Setup

#### Wired Connection
If you're using a wired connection, it should be configured automatically via DHCP.

#### Wireless Connection
For wireless, the installer uses `iwd` for easier configuration:

```bash
# Start iwctl interactive mode
sudo iwctl

# In iwctl, scan for networks and connect
[iwd]# station wlan0 scan
[iwd]# station wlan0 get-networks
[iwd]# station wlan0 connect "Your-WiFi-Name"
# Enter password when prompted
[iwd]# exit
```

Verify connectivity:
```bash
ip a
ping google.com
```

### Installing NixOS

Set the hostname:
```bash
sudo hostnamectl set-hostname rpi5
```

Clone your nix-config repository:
```bash
git clone https://github.com/JamieMagee/nix-config.git
cd nix-config
```

> [!NOTE]
> The installer image already includes the `nixos-raspberrypi` flake input, so you don't need to add it manually.

Build and install your configuration:
```bash
# If using the standard SD card setup (as in your current config)
sudo nixos-rebuild switch --flake .#rpi5

# If you want to partition and format additional storage with disko
# (for example, an NVMe SSD connected via PCIe)
sudo nix run github:nix-community/disko -- --mode disko ./path/to/your/disko-config.nix
sudo nixos-rebuild switch --flake .#rpi5
```

### Post-installation

After the installation completes:

1. **Set up user passwords:**
   ```bash
   sudo passwd jamie  # Set password for your user
   sudo passwd        # Set root password
   ```

2. **Reboot to ensure everything works:**
   ```bash
   sudo reboot
   ```

### Remote Management

Once the system is running, you can manage it remotely using the included deploy-rs configuration:

```bash
# Deploy system configuration
nix run github:serokell/deploy-rs -- .#rpi5

# Deploy home-manager configuration
nix run github:serokell/deploy-rs -- .#rpi5.home
```
