{
  services.home-assistant.config.automation = [
    {
      alias = "Backup Home Assistant daily";
      trigger = {
        platform = "time";
        at = "03:00:00";
      };
      action = {
        service = "backup.create";
      };
    }
  ];
}
