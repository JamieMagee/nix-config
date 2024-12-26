{
  services.sonarr = {
    enable = true;
  };

  services.caddy.virtualHosts."alfred.tailnet-0b15.ts.net" = {
    extraConfig = ''
      reverse_proxy /sonarr* http://[::1]:8989
    '';
  };

  # https://github.com/NixOS/nixpkgs/issues/360592
  nixpkgs.config.permittedInsecurePackages =  [
    "aspnetcore-runtime-6.0.36"
    "dotnet-sdk-6.0.428"
  ];
}
