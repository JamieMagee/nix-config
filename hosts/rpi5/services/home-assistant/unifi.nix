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
              trigger = "event.received";
              target = {
                entity_id = "event.g4_doorbell_pro_doorbell";
              };
              options = {
                event_type = [ "ring" ];
              };
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
                  tag = "doorbell";
                  notification_icon = "mdi:doorbell-video";
                  clickAction = "/nixos-lovelace/0";
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
