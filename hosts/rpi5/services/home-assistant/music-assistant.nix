{
  services = {
    home-assistant = {
      extraComponents = [ "music_assistant" ];
    };
    music-assistant = {
      enable = true;
      providers = [
        "chromecast"
        "plex"
        "sonos"
        "spotify"
      ];
    };
  };
}
