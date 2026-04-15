{
  additions = final: _prev: import ../pkgs { pkgs = final; };

  modifications = final: prev: {
    github-copilot-cli = prev.github-copilot-cli.overrideAttrs (old: rec {
      version = "1.0.27";
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
            x86_64-linux = "sha256-OlUcbcghYEFnUTK1P9rq85Xnge7tTCPdAr1g1kDYByI=";
            aarch64-linux = "sha256-UMDEk0rxGY7DR6x83HzE9J3oGSKAvSquyB0LpKOzwPs=";
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
