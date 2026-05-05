final: prev: {
  github-copilot-cli = prev.github-copilot-cli.overrideAttrs (_old: rec {
    version = "1.0.41";
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
          x86_64-linux = "sha256-7q10TbxGWREQzt5/B4zcoHCOzGc+Q/x1cuAdKSu13fs=";
          aarch64-linux = "sha256-fVt3zgz4seseWMUHIWGZ/FHPpPuYe9btRswySD63+lc=";
        }
        .${final.stdenv.hostPlatform.system}
          or (throw "Unsupported system: ${final.stdenv.hostPlatform.system}");
    };
  });
}
