# Raspberry Pi 4

This is a condensed and modified version of [the installation guide on nix.dev][1] for my specific setup.

## Installation

### Prerequisites

The first part of the installation is to flash an SD card with a NixOS image.

> [!NOTE]
> If you're using Windows, you'll need to use the [Raspberry Pi Imager][2]

```bash
curl -Lo nixos-sd-image-aarch64.img.zst https://hydra.nixos.org/job/nixos/trunk-combined/nixos.sd_image.aarch64-linux/latest/download-by-type/file/sd-image
zstd -d nixos-sd-image-aarch64.img.zst
sudo dd if=nixos-sd-image-aarch64.img of=/dev/sdX bs=4096 conv=fsync status=progress
```

Once the image is flashed, you can move the SD card to the Raspberry Pi and boot.

### First boot

> [!IMPORTANT]
> Run `sudo -i` to get a root shell.
> Otherwise, you'll need to prefix all commands with `sudo`.

### Getting an internet connection

If you're using a wired connection, you can skip this step.

```bash
wpa_supplicant -B -i wlan0 -c <(wpa_passphrase "SSID" "password")
```

Verify that you have an IP address:

```bash
ip a
```

### Updating the firmware

The firmware on the SD card is likely out of date, so we need to update it:

```bash
nix-shell -p raspberrypi-eeprom
mount /dev/disk/by-label/FIRMWARE /mnt
BOOTFS=/mnt FIRMWARE_RELEASE_STATUS=stable rpi-eeprom-update -d -a
```

### Installing NixOS

Set the hostname:

```bash
hostname rpi
```

Clone the nix-config repo:

```bash
nix-shell -p git
git clone https://github.com/JamieMagee/nix-config.git
```

Start a nix-shell:

```bash
cd nix-config
nix-shell
```

Rebuild the system configuration:

```bash
nixos-rebuild boot --flake .
```

Then set the password for the `root` user and reboot:

```bash
passwd
reboot now
```

### Home-manager

Login with the `root` user then set the password for the `jamie` user:

```bash
passwd jamie
```

Logout and login with the `jamie` user.
Create the home-manager directory and remove the default fish config:

```bash
mkdir -p ~/.local/state/nix/profiles
rm ~/.config/fish/config.fish
```

Clone the nix-config repository again:

```bash
git clone https://github.com/JamieMagee/nix-config.git
```

Start a nix-shell:

```bash
cd nix-config
nix-shell
```

Then install the home-manager configuration

```bash
home-manager --flake . switch
```

Finally, login with tailscale:

```bash
tailscale up --ssh
```

And disable the key expiry from the [Tailscale admin console][3]

[1]: https://nix.dev/tutorials/nixos/installing-nixos-on-a-raspberry-pi
[2]: https://www.raspberrypi.com/software/
[3]: https://login.tailscale.com/admin/machines
