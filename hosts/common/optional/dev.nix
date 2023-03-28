{pkgs, ...}: {
  environment.systemPackages = with pkgs;
    [
      (with dotnetCorePackages;
        combinePackages [
          sdk_3_1
          sdk_6_0
          sdk_7_0
          sdk_8_0
        ])
      nodejs-19_x
    ]
    ++ (with nodePackages_latest; [npm pnpm yarn]);
}
