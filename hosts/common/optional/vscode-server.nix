{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.vscode-server.nixosModules.default
  ];
  services.vscode-server.enable = true;
}
