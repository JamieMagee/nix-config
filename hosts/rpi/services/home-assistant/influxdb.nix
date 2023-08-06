{pkgs, ...}: {
  services.influxdb = {
    enable = true;
  };

  services.home-assistant = {
    extraComponents = [
      "influxdb"
    ];
    config = {
      influxdb = {
        include = {
          entities = [
            "person.jamie"
            "person.kat"
          ];
        };
      };
    };
  };
}
