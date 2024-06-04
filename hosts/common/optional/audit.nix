{
  security = {
    audit = {
      enable = true;
      rules = [
        "-w /dev/ttyUSB0 -p rwxa"
        "-w /dev/serial/by-id/usb-Nabu_Casa_SkyConnect_v1.0_a61ce607b596ed11b11cc498a7669f5d-if00-port0 -p rwxa"
      ];
    };
    auditd.enable = true;
  };
}
