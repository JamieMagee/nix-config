{
  services.home-assistant.config = {
    notify = [
      {
        platform = "group";
        name = "Everyone";
        services = [
          {
            service = "mobile_app_pixel_5";
          }
          {
            service = "mobile_app_pixel_6";
          }
        ];
      }
    ];
  };
}
