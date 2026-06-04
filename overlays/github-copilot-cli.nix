final: prev: {
  github-copilot-cli = prev.github-copilot-cli.overrideAttrs (old: rec {
    version = "1.0.59";

    src = final.fetchurl {
      url = "https://github.com/github/copilot-cli/releases/download/v${version}/github-copilot-${version}.tgz";
      hash = "sha256-ekMkKJSBVwd7EsaB1L5xxI322r4HMB4A3ehm4cE5dTE=";
    };

    # musl libc deps that upstream's ignore list doesn't cover.
    autoPatchelfIgnoreMissingDeps = (old.autoPatchelfIgnoreMissingDeps or [ ]) ++ [
      "libc.musl-x86_64.so.1"
      "libc.musl-aarch64.so.1"
    ];
  });
}
