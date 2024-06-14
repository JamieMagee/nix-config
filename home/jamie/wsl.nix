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
    packages =
      with pkgs;
      [
        go
        nodejs_22
        wslu
        (
          with dotnetCorePackages;
          combinePackages [
            sdk_6_0
            sdk_7_0
            sdk_8_0
          ]
        )
      ]
      ++ (with nodePackages_latest; [
        pnpm
        yarn
      ]);
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
