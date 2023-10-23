{pkgs, ...}: {
  systemd.services.hd-idle = {
    description = "HDD spin down daemon";
    wantedBy = ["multi-user.target"];
    serviceConfig = {
      Type = "simple";
      ExecStart = ''
        ${pkgs.hd-idle}/bin/hd-idle -i 0 \
            -a sda -i 600 \
            -a sdb -i 600 \
            -a sdc -i 600 \
            -a sdd -i 600 \
            -a sde -i 600
      '';
    };
  };
}
