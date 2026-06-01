final: prev: {
  github-copilot-cli = prev.github-copilot-cli.overrideAttrs (old: rec {
    version = "1.0.56";

    src = final.fetchurl {
      url = "https://github.com/github/copilot-cli/releases/download/v${version}/github-copilot-${version}.tgz";
      hash = "sha256-CBuexOFdLFeQRQtR4Maf83EUVgjAUJCpM0USU8+nRnw=";
    };

    # musl libc deps that upstream's ignore list doesn't cover.
    autoPatchelfIgnoreMissingDeps = (old.autoPatchelfIgnoreMissingDeps or [ ]) ++ [
      "libc.musl-x86_64.so.1"
      "libc.musl-aarch64.so.1"
    ];
  });
}
