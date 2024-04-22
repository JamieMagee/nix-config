{ pkgs, ... }:
{
  programs.micro = {
    enable = true;
    settings = { };
  };

  home.sessionVariables = {
    EDITOR = "${pkgs.micro}/bin/micro";
  };
}
