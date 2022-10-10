{pkgs, ...}: {
  home.packages = with pkgs;
  with jetbrains; [
    idea-ultimate
    rider
    webstorm
  ];
}
