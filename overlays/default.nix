{
  additions = final: _prev: import ../pkgs { pkgs = final; };

  modifications = final: prev: {
    github-copilot-cli = prev.github-copilot-cli.overrideAttrs (old: rec {
      version = "1.0.25";
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
            x86_64-linux = "sha256-aSpf90YDJ6vlzyRP2SZX1ceeKHzeOTVDnlYK27UHqTU=";
            aarch64-linux = "sha256-/RSOhBEFipjTJn+nCFS6WUsN+CwSafi818u0FouE+V0=";
          }
          .${final.stdenv.hostPlatform.system}
            or (throw "Unsupported system: ${final.stdenv.hostPlatform.system}");
      };
    });

  };
}
