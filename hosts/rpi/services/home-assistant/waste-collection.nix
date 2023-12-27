{
  services.home-assistant.config = {
    waste_collection_schedule = {
      sources = [
        {
          name = "seattle_gov";
          args = {
            street_address = "!secret address";
          };
        }
      ];
    };

    sensor = [
      {
        platform = "waste_collection_schedule";
        name = "Seattle garbage collection";
      }
    ];
  };
}
