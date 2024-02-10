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
    wslu
  ];
}
