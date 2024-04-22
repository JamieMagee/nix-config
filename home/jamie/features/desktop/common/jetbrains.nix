{ pkgs, ... }:
{
  home.packages =
    with pkgs;
    with jetbrains;
    [
      # IDE
      gateway
      idea-ultimate
      rider
      webstorm

      #plugins
      github-copilot-intellij-agent
    ];
}
