{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
  specialized-turbo,
}:

buildHomeAssistantComponent rec {
  owner = "JamieMagee";
  domain = "specialized_turbo";
  version = "0.1.5";

  src = fetchFromGitHub {
    owner = "JamieMagee";
    repo = "ha-specialized-turbo";
    tag = "v${version}";
    hash = "sha256-1e5TiD1Fas9D+j/maZ3AL7OmoaAzuNcpVWeQWR40yFs=";
  };

  dependencies = [
    specialized-turbo
  ];

  ignoreVersionRequirement = [
    "specialized-turbo"
  ];

  meta = {
    description = "Home Assistant integration for Specialized Turbo e-bikes";
    homepage = "https://github.com/JamieMagee/ha-specialized-turbo";
    license = lib.licenses.mit;
  };
}
