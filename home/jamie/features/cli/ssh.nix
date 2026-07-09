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
      "build05.ynh.ovh build06.ynh.ovh build07.ynh.ovh build08.ynh.ovh" = {
        User = "jamie";
        Port = 22;
        IdentityFile = "~/.ssh/id_ed25519_sk";
        IdentitiesOnly = true;
        ControlMaster = "auto";
        ControlPath = "~/.ssh/cm-%C";
        ControlPersist = "60m";
      };
      "nix-build-arm" = {
        HostName = "aarch64-build-box.nix-community.org";
        User = "jamiemagee";
        IdentityFile = "~/.ssh/id_ed25519_sk";
        IdentitiesOnly = true;
        ControlMaster = "auto";
        ControlPath = "~/.ssh/cm-%C";
        ControlPersist = "60m";
      };
    };
  };
}
