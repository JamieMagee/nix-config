_final: prev: {
  pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
    (_pyfinal: pyprev: {
      elgato = pyprev.elgato.overridePythonAttrs (old: {
        # Typer vendors Click, so its groups are not standalone click.Group instances.
        postPatch = (old.postPatch or "") + ''
          substituteInPlace tests/cli/test_cli.py \
            --replace-fail "import click" "from typer.core import TyperGroup" \
            --replace-fail "click.Group" "TyperGroup"
        '';
      });
    })
  ];
}
