{ pkgs, ... }:
{
  home.packages =
    with pkgs;
    with jetbrains;
    [
      # IDE
      gateway
      idea
      rider
      webstorm

      #plugins
      github-copilot-intellij-agent
    ];
}
