{
  additions = final: _prev: import ../pkgs { pkgs = final; };

  modifications = final: prev: {
    mcp-nixos = prev.mcp-nixos.overridePythonAttrs {
      doCheck = false;
    };
  };
}
