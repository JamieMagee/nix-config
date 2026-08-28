{ pkgs, ... }:
let
  tailscale = pkgs.tailscale;
  tailscaleCli = pkgs.writeShellScriptBin "tailscale" ''
    if [[ -z "''${XDG_RUNTIME_DIR:-}" ]]; then
      echo "XDG_RUNTIME_DIR is not set. Start a systemd user session." >&2
      exit 1
    fi

    exec ${tailscale}/bin/tailscale \
      --socket="$XDG_RUNTIME_DIR/tailscale/tailscaled.sock" \
      "$@"
  '';
in
{
  home.packages = [ tailscaleCli ];

  systemd.user.services.tailscaled = {
    Unit = {
      Description = "Tailscale node agent";
      Documentation = [ "https://tailscale.com/docs/" ];
    };

    Service = {
      Type = "notify";
      ExecStart = "${tailscale}/bin/tailscaled --tun=userspace-networking --statedir=%S/tailscale --socket=%t/tailscale/tailscaled.sock";
      Restart = "on-failure";
      RestartSec = 5;
      CacheDirectory = "tailscale";
      CacheDirectoryMode = "0700";
      RuntimeDirectory = "tailscale";
      RuntimeDirectoryMode = "0700";
      StateDirectory = "tailscale";
      StateDirectoryMode = "0700";
      UMask = "0077";
    };

    Install.WantedBy = [ "default.target" ];
  };
}
