{
  services.home-assistant = {
    extraComponents = [
      "unifi"
      "unifiprotect"
    ];
    config = {
      automation = [
        {
          alias = "Doorbell";
          id = "doorbell";
          triggers = [
            {
              trigger = "state";
              entity_id = "binary_sensor.g4_doorbell_pro_doorbell";
              to = "on";
            }
          ];
          actions = [
            {
              action = "notify.everyone";
              data = {
                title = "Doorbell";
                message = "There's someone at the door";
                data = {
                  image = "/api/camera_proxy/camera.g4_doorbell_pro_high";
                };
              };
            }
            {
              action = "elgato.identify";
              target = {
                entity_id = [
                  "light.jamie_ring_light"
                  "light.kat_ring_light"
                ];
              };
            }
          ];
        }
      ];
    };
  };
}
