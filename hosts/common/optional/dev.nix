{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # .NET SDKs
    dotnetCorePackages.sdk_6_0
    dotnetCorePackages.sdk_8_0
    dotnetCorePackages.sdk_9_0

    # Node.js and package managers
    nodejs_22
    nodePackages_latest.npm
    nodePackages_latest.pnpm
    nodePackages_latest.yarn

    # System tools
    nix-ld
  ];
}
