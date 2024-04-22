{ inputs, ... }:
{
  imports = [
    ./global

    ./features/cli
    ./features/desktop/common
  ];
  colorscheme = inputs.nix-colors.colorSchemes.nord;
}
