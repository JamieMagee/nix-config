{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    ./global

    ./features/cli
    ./features/cli/ruby.nix
  ];

  home.packages = with pkgs; [
    nodejs_21
    wslu
  ]
  ++ (with nodePackages_latest; [pnpm yarn]);
}
