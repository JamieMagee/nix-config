{
  security = {
    audit = {
      enable = true;
      rules = [
        "-w /dev/ttyUSB0 -p rwxa"
      ];
    };
    auditd.enable = true;
  };
}
