{
  services.home-assistant.config.automation = [
    {
      alias = "Backup Home Assistant daily";
      triggers = {
        trigger = "time";
        at = "03:00:00";
      };
      actions = {
        action = "backup.create";
      };
    }
  ];
}
