{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    bicep

    # .NET SDKs
    (
      with dotnetCorePackages;
      combinePackages [
        sdk_8_0
        sdk_9_0
        sdk_10_0
      ]
    )

    # Node.js and package managers
    nodejs_24
    nodePackages_latest.npm
    nodePackages_latest.pnpm
    nodePackages_latest.yarn

    # System tools
    nix-ld
  ];
}
