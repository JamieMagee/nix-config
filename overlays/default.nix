{
  additions = final: _prev: import ../pkgs { pkgs = final; };

  # Temporary fix for mechanize Python 3.13 compatibility and test failure
  # Can be removed once nixos-raspberrypi uses a newer nixpkgs
  mechanize-fix = final: prev: {
    python3 = prev.python3.override {
      packageOverrides = pfinal: pprev: {
        mechanize = pprev.mechanize.overrideAttrs (oldAttrs: {
          patches = (oldAttrs.patches or [ ]) ++ [
            (prev.fetchpatch {
              name = "fix-cookietests-python3.13.patch";
              url = "https://github.com/python-mechanize/mechanize/commit/0c1cd4b65697dee4e4192902c9a2965d94700502.patch";
              hash = "sha256-Xlx8ZwHkFbJqeWs+/fllYZt3CZRu9rD8bMHHPuUlRv4=";
            })
          ];
        });
      };
    };
  };
}
