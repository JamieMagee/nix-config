final: prev: {
  github-copilot-cli = prev.github-copilot-cli.overrideAttrs (_old: rec {
    version = "1.0.39";
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
          x86_64-linux = "sha256-Zt3qZhKlYhrcc01uos4VDLhWgqPjLwi/kGlfwpN0YWo=";
          aarch64-linux = "sha256-0SjuXPfS5+xsh1Ec/LEfPgcrtnlhjKmkZdow8Ie/3oY=";
        }
        .${final.stdenv.hostPlatform.system}
          or (throw "Unsupported system: ${final.stdenv.hostPlatform.system}");
    };
  });
}
