To build locally and push to the `rpi`:

```
nixos-rebuild --target-host jamie@rpi --use-remote-sudo --flake .#rpi switch
```