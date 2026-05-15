final: prev: {
  github-copilot-cli = prev.github-copilot-cli.overrideAttrs (_old: rec {
    version = "1.0.48";
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
          x86_64-linux = "sha256-8qEnjDwv4iy8vlHA0u4lH3Yh0uoiEf4cezZoqzs2P/0=";
          aarch64-linux = "sha256-Wle9EaLxdwpDP54EG945xleDj32k97fAWdpXUKZpq3s=";
        }
        .${final.stdenv.hostPlatform.system}
          or (throw "Unsupported system: ${final.stdenv.hostPlatform.system}");
    };
  });
}
