_final: prev: {
  pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
    (_pyfinal: pyprev: {
      pyjwt = pyprev.pyjwt.overridePythonAttrs (_old: rec {
        version = "2.15.1";
        src = prev.fetchFromGitHub {
          owner = "jpadilla";
          repo = "pyjwt";
          tag = version;
          hash = "sha256-C2l0QN8Vg2WkWniAfN/jpC6LAuy6gjcigzK1dvfJnj8=";
        };
      });
    })
  ];
}
