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
          sdk_8_0
          sdk_9_0
          sdk_10_0
        ]
      )

      # Node.js and package managers
      nodejs_22
      nodePackages_latest.pnpm
      nodePackages_latest.yarn

      # Go
      go_1_24

      # System tools
      wslu
    ];
  };

  programs = {
    zellij = {
      attachExistingSession = lib.mkForce false;
      exitShellOnExit = lib.mkForce false;
    };
    git.extraConfig = {
      credential = {
        "https://dev.azure.com" = {
          helper = "/mnt/c/Program\\ Files/Git/mingw64/bin/git-credential-manager.exe";
          useHttpPath = true;
        };
      };
    };
  };
}
