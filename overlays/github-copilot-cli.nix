final: prev: {
  github-copilot-cli = prev.github-copilot-cli.overrideAttrs (old: rec {
    version = "1.0.60";

    src = final.fetchurl {
      url = "https://github.com/github/copilot-cli/releases/download/v${version}/github-copilot-${version}.tgz";
      hash = "sha256-wUEBstKx8Yb9m6ynIi137ZXR7dO39uepnv/yGFVE/qQ=";
    };

    # musl libc deps that upstream's ignore list doesn't cover.
    autoPatchelfIgnoreMissingDeps = (old.autoPatchelfIgnoreMissingDeps or [ ]) ++ [
      "libc.musl-x86_64.so.1"
      "libc.musl-aarch64.so.1"
    ];
  });
}
