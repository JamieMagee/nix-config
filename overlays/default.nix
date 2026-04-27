{
  additions = final: _prev: import ../pkgs { pkgs = final; };

  modifications = final: prev: {
    github-copilot-cli = prev.github-copilot-cli.overrideAttrs (old: rec {
      version = "1.0.36";
      src = final.fetchurl {
        url = "https://github.com/github/copilot-cli/releases/download/v${version}/${
          {
            x86_64-linux = "copilot-linux-x64";
            aarch64-linux = "copilot-linux-arm64";
          }
          .${final.stdenv.hostPlatform.system}
            or (throw "Unsupported system: ${final.stdenv.hostPlatform.system}")
        }.tar.gz";
        hash =
          {
            x86_64-linux = "sha256-m4oAqmFA4LbrAkUmL30/i9sXCi54Jgms3z0ga7wntDE=";
            aarch64-linux = "sha256-/FYLOxnbVhvEN5p+e+hT+KStG4/AwQlVlVORSnN9xRM=";
          }
          .${final.stdenv.hostPlatform.system}
            or (throw "Unsupported system: ${final.stdenv.hostPlatform.system}");
      };
    });

    # yalexs test dependency aiounittest is disabled for python 3.14
    pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
      (_python-final: python-prev: {
        yalexs = python-prev.yalexs.overridePythonAttrs {
          doCheck = false;
        };
      })
    ];
  };
}
