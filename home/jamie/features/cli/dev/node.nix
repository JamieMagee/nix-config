{pkgs, ...}: {
  home.packages = with pkgs;
    [
      nodejs-19_x
    ]
    ++ (with nodePackages; [yarn]);
}
