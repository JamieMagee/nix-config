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
          trigger = [
            {
              platform = "state";
              entity_id = "binary_sensor.g4_doorbell_pro_doorbell";
              to = "on";
            }
          ];
          action = [
            {
              service = "notify.everyone";
              data = {
                title = "Doorbell";
                message = "There's someone at the door";
                data = {
                  image = "/api/camera_proxy/camera.g4_doorbell_pro_high";
                };
              };
            }
            {
              service = "elgato.identify";
              target = {
                entity_id = [
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
