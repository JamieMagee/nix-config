final: prev: {
  github-copilot-cli = prev.github-copilot-cli.overrideAttrs (_old: rec {
    version = "1.0.40";
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
          x86_64-linux = "sha256-ETlF92PA96vJX3oEBeQpxYV6oKhCK0EwAEiy35kGzPY=";
          aarch64-linux = "sha256-PxO+OiogtG0S8OChIVAh1WXC4UJSMn67cayiDtMKwAs=";
        }
        .${final.stdenv.hostPlatform.system}
          or (throw "Unsupported system: ${final.stdenv.hostPlatform.system}");
    };
  });
}
