final: prev: {
  github-copilot-cli = prev.github-copilot-cli.overrideAttrs (old: rec {
    version = "1.0.58";

    src = final.fetchurl {
      url = "https://github.com/github/copilot-cli/releases/download/v${version}/github-copilot-${version}.tgz";
      hash = "sha256-RvmvEEDVJmQ1LF56E5oDe8UNXKXIEcdpv0og79dbNDc=";
    };

    # musl libc deps that upstream's ignore list doesn't cover.
    autoPatchelfIgnoreMissingDeps = (old.autoPatchelfIgnoreMissingDeps or [ ]) ++ [
      "libc.musl-x86_64.so.1"
      "libc.musl-aarch64.so.1"
    ];
  });
}
