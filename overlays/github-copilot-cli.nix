final: prev: {
  github-copilot-cli = prev.github-copilot-cli.overrideAttrs (old: rec {
    version = "1.0.54";

    # Use the universal package; the SEA binary has hard-coded paths that
    # don't work reliably under Nix.
    src = final.fetchurl {
      url = "https://github.com/github/copilot-cli/releases/download/v${version}/github-copilot-${version}.tgz";
      hash = "sha256-WkJtCfapWdmZPPDEtfZhDJzgPgcI2NpTgukCyhBfzcY=";
    };

    sourceRoot = "package";

    buildInputs =
      (old.buildInputs or [ ])
      ++ final.lib.optionals final.stdenv.hostPlatform.isLinux [
        final.glib
        final.libsecret
      ];

    # computer.node requires GUI/media libs that aren't relevant for CLI use.
    autoPatchelfIgnoreMissingDeps = [
      "libX11.so.6"
      "libXtst.so.6"
      "libjpeg.so.8"
      "libpng16.so.16"
      "libpipewire-0.3.so.0"
      "libei.so.1"
      "libc.musl-x86_64.so.1"
      "libc.musl-aarch64.so.1"
    ];

    installPhase = ''
      runHook preInstall
      mkdir -p "$out"/lib/github-copilot-cli
      cp -r * "$out"/lib/github-copilot-cli
      runHook postInstall
    '';

    postInstall = ''
      makeWrapper ${final.nodejs}/bin/node "$out"/bin/copilot \
        --add-flag "$out"/lib/github-copilot-cli/index.js \
        --add-flag --no-auto-update \
        --set-default NODE_NO_WARNINGS 1 \
        --set-default SSL_CERT_DIR ${final.cacert}/etc/ssl/certs \
        --prefix PATH : "${final.lib.makeBinPath [ final.bash ]}"
    '';
  });
}
