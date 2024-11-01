{
  inputs,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ./global

    ./features/cli
    ./features/cli/ruby.nix
  ];

  home = {
    packages = with pkgs; [
      # .NET SDKs
      (
        with dotnetCorePackages;
        combinePackages [
          sdk_6_0
          sdk_8_0
          sdk_9_0
        ]
      )

      # Node.js and package managers
      nodejs_22
      nodePackages_latest.pnpm
      nodePackages_latest.yarn

      # Go
      go_1_23

      # System tools
      wslu
    ];
    sessionVariables = {
      "ZELLIJ_AUTO_ATTACH" = lib.mkForce "false";
      "ZELLIJ_AUTO_EXIT" = lib.mkForce "false";
    };
  };

  programs.git.extraConfig = {
    credential = {
      "https://dev.azure.com" = {
        helper = "/mnt/c/Program\\ Files/Git/mingw64/bin/git-credential-manager.exe";
        useHttpPath = true;
      };
    };
  };
}
