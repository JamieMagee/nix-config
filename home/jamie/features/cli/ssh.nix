{
  programs.ssh = {
    enable = true;
    matchBlocks = {
      "*-tailnet" = {
        host = "*.tailnet-0b15.ts.net";
        user = "jamie";
        port = 2222;
        forwardAgent = true;
        identitiesOnly = true;
      };
      "rpi5" = {
        host = "rpi5.tailnet-0b15.ts.net";
      };
      "alfred" = {
        host = "alfred.tailnet-0b15.ts.net";
      };
      "jamie-desktop" = {
        host = "jamie-desktop.tailnet-0b15.ts.net";
      };
    };
  };
}
