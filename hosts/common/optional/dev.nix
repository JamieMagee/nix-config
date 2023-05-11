{pkgs, ...}: {
  environment.systemPackages = with pkgs;
    [
      (with dotnetCorePackages;
        combinePackages [
          sdk_6_0
          sdk_7_0
          sdk_8_0
        ])
      nodejs_20
      nix-ld
    ]
    ++ (with nodePackages_latest; [npm pnpm yarn]);
}
