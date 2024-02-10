{inputs, ...}: {
  imports = [
    ./global

    ./features/cli
    ./features/cli/ruby.nix
  ];
}
