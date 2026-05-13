final: prev: {
  github-copilot-cli = prev.github-copilot-cli.overrideAttrs (_old: rec {
    version = "1.0.46";
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
          x86_64-linux = "sha256-W9Pt0BmBtBLHBQFEJ7odHVRTSVkMDs/bqccHADL7yQc=";
          aarch64-linux = "sha256-fogmrpfKIIc6De0VP1P0f7LUo29o2CwLlneN1G0mM+s=";
        }
        .${final.stdenv.hostPlatform.system}
          or (throw "Unsupported system: ${final.stdenv.hostPlatform.system}");
    };
  });
}
