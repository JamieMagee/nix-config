{
  additions = final: _prev: import ../pkgs { pkgs = final; };

  modifications = final: prev: {
    mcp-nixos = prev.mcp-nixos.overridePythonAttrs {
      doCheck = false;
    };

    pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
      (python-final: python-prev: {
        yalexs = python-prev.yalexs.overridePythonAttrs {
          doCheck = false;
        };
        radios = python-prev.radios.overridePythonAttrs {
          pythonRelaxDeps = [ "pycountry" ];
        };
      })
    ];
  };
}
