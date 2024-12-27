{
  services.home-assistant = {
    extraComponents = [ "cloud" ];
    config = {
      cloud = { };
    };
  };
}
