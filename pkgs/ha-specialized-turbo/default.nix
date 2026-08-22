{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
  specialized-turbo,
}:

buildHomeAssistantComponent rec {
  owner = "JamieMagee";
  domain = "specialized_turbo";
  version = "0.5.8";

  src = fetchFromGitHub {
    owner = "JamieMagee";
    repo = "ha-specialized-turbo";
    tag = "v${version}";
    hash = "sha256-iGV6jrVsdNoV259nqQ18N9Yp2487O+0ZF/5Uul7q8U8=";
  };

  dependencies = [
    specialized-turbo
  ]
  ++ specialized-turbo.optional-dependencies.cloud;

  ignoreVersionRequirement = [
    "specialized-turbo"
  ];

  meta = {
    description = "Home Assistant integration for Specialized Turbo e-bikes";
    homepage = "https://github.com/JamieMagee/ha-specialized-turbo";
    license = lib.licenses.mit;
  };
}
