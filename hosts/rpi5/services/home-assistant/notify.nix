{
  services.home-assistant.config = {
    notify = [
      {
        platform = "group";
        name = "Everyone";
        services = [
          { service = "mobile_app_kat_pixel_8a"; }
          { service = "mobile_app_jamie_pixel_8a"; }
        ];
      }
    ];
  };
}
