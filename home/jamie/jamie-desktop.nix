{inputs, ...}: {
  imports = [
    ./global

    ./features/cli
    ./features/cli/dev
    ./features/desktop/common
  ];
  colorscheme = inputs.nix-colors.colorSchemes.nord;
}
