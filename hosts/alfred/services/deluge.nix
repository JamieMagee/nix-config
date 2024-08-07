{
  services.deluge = {
    enable = true;
    web = {
      enable = true;
    };
    config = {
      outgoing_interface = "wg0";
    };
  };

}
