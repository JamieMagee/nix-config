{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
  specialized-turbo,
}:

buildHomeAssistantComponent rec {
  owner = "JamieMagee";
  domain = "specialized_turbo";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "JamieMagee";
    repo = "ha-specialized-turbo";
    rev = "9f2cbed9152b99fadd835022699f19c42ee148bc";
    hash = "sha256-2aSmzRmNm8uGOO+gFVFzo/PuUx/QMU+GEaFy7UQwR/4=";
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
