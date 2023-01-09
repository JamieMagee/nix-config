{
  programs.ssh = {
    enable = true;
    matchBlocks = {
      "rpi" = {
        host = "rpi.tailnet-0b15.ts.net";
        user = "jamie";
        port = 2222;
        forwardAgent = true;
        identitiesOnly = true;
      };
      "alfred" = {
        host = "alfred.tailnet-0b15.ts.net";
        user = "jamie";
        port = 2222;
        forwardAgent = true;
        identitiesOnly = true;
      };
      "jamie-desktop" = {
        host = "jamie-desktop.tailnet-0b15.ts.net";
        user = "jamie";
        port = 2222;
        forwardAgent = true;
        identitiesOnly = true;
      };
    };
  };
}
