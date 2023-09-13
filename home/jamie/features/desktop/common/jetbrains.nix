{pkgs, ...}: {
  home.packages = with pkgs;
  with jetbrains; [
    # IDE
    idea-ultimate
    rider
    webstorm

    #plugins
    github-copilot-intellij-agent
  ];
}
