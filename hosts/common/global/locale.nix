{ lib, ... }:
{
  i18n = {
    defaultLocale = lib.mkDefault "en_GB.UTF-8";
    supportedLocales = lib.mkDefault [ "en_GB.UTF-8/UTF-8" ];
  };
  console.keyMap = lib.mkDefault "uk";
  time.timeZone = lib.mkDefault "America/Los_Angeles";
}
