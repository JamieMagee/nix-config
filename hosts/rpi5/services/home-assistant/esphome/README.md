# ESPHome mini split configs

Three ESP32-C3 boards wired to Mitsubishi mini splits via CN105. They use the [echavet/MitsubishiCN105ESPHome](https://github.com/echavet/MitsubishiCN105ESPHome) external component and double as Bluetooth proxies.

## Devices

| Config | Hostname | Area |
| --- | --- | --- |
| bedroom-mini-split.yaml | esphome-web-6c4990.local | Bedroom |
| office-mini-split.yaml | esphome-web-6ab408.local | Office |
| downstairs-mini-split.yaml | esphome-web-6c37b0.local | Living Room |

## Flashing

Compile and push OTA from your local machine (no need to build on the rpi5):

```bash
uvx esphome run bedroom-mini-split.yaml --device esphome-web-6c4990.local
uvx esphome run office-mini-split.yaml --device esphome-web-6ab408.local
uvx esphome run downstairs-mini-split.yaml --device esphome-web-6c37b0.local
```

This uses `uvx` to run ESPHome in a temporary venv. It compiles the firmware locally, then pushes it to the device over WiFi OTA. Takes about a minute per device.

If a device isn't reachable by mDNS hostname, use its IP instead (check your router or HA for the current address).

## Secrets

The configs reference `!secret wifi_ssid`, `!secret wifi_password`, and `!secret api_key`. ESPHome looks for a `secrets.yaml` in the same directory as the config file. Create one if it doesn't exist:

```yaml
wifi_ssid: "your-ssid"
wifi_password: "your-password"
api_key: "your-api-key"
```

## Hardware

- Board: ESP32-C3-DevKitM-1
- UART: TX=GPIO21, RX=GPIO20, 2400 baud, 8E1
- Connection: CN105 header on the mini split indoor unit

## If something goes wrong

Wrong UART pins or climate settings? The device still has WiFi and API, so just fix the config and OTA again.

Wrong API key or WiFi credentials? You'll need a USB cable to reflash. Plug into the C3's USB port and run:

```bash
uvx esphome run bedroom-mini-split.yaml --device /dev/ttyACM0
```
