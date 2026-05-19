{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    settings = {
      "*-tailnet" = {
        Host = "*.tailnet-0b15.ts.net";
        User = "jamie";
        Port = 2222;
        ForwardAgent = true;
        IdentitiesOnly = true;
      };
      "rpi5" = {
        Host = "rpi5.tailnet-0b15.ts.net";
      };
      "alfred" = {
        Host = "alfred.tailnet-0b15.ts.net";
      };
      "jamie-desktop" = {
        Host = "jamie-desktop.tailnet-0b15.ts.net";
      };
    };
  };
}
