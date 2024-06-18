{
  services.home-assistant.config = {
    notify = [
      {
        platform = "group";
        name = "Everyone";
        services = [
          { service = "mobile_app_kat_s_pixel"; }
          { service = "mobile_app_jamie_pixel_8a"; }
        ];
      }
    ];
  };
}
