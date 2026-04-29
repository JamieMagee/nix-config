{
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ./global

    ./features/cli
    ./features/cli/mcp.nix
    ./features/cli/opencode.nix
    ./features/cli/podman.nix
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
          sdk_11_0
        ]
      )

      # Node.js and package managers
      nodejs_24
      pnpm
      yarn
      biome

      # Go
      go_1_26

      github-copilot-cli

      yt-dlp
    ];
  };

  programs = {
    zellij = {
      attachExistingSession = lib.mkForce false;
      exitShellOnExit = lib.mkForce false;
    };
    git.settings = {
      credential = {
        "https://dev.azure.com" = {
          helper = "/mnt/c/Program\\ Files/Git/mingw64/bin/git-credential-manager.exe";
          useHttpPath = true;
        };
        "https://*.visualstudio.com" = {
          helper = "/mnt/c/Program\\ Files/Git/mingw64/bin/git-credential-manager.exe";
          useHttpPath = true;
        };
      };
    };
  };
}
