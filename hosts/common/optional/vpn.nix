{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [ wireguard-tools ];

  # Brief Emu
  networking = {
    iproute2 = {
      enable = true;
      rttablesExtraConfig = ''
        200 vpn
      '';
    };

    wg-quick.interfaces.wg0 = {
      table = "vpn";
      address = [
        "10.67.22.132/32"
        "fc00:bbbb:bbbb:bb01::4:1683/128"
      ];
      privateKeyFile = "/home/jamie/wg.key";
      # dns = [ "100.64.0.63" ];
      peers = [
        {
          publicKey = "bZQF7VRDRK/JUJ8L6EFzF/zRw2tsqMRk6FesGtTgsC0=";
          allowedIPs = [
            "0.0.0.0/0"
            "::0/0"
          ];
          endpoint = "138.199.43.91:51820";
          persistentKeepalive = 25;
        }
      ];
    };
  };
}
