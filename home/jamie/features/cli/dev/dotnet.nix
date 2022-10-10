{pkgs, ...}: {
  home.packages = [
    (with pkgs.dotnetCorePackages;
      combinePackages [
        sdk_3_1
        sdk_6_0
        sdk_7_0
      ])
  ];
}
