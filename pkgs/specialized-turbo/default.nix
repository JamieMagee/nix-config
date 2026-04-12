{
  lib,
  home-assistant,
  fetchFromGitHub,
}:

home-assistant.python.pkgs.buildPythonPackage rec {
  pname = "specialized-turbo";
  version = "0.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "JamieMagee";
    repo = "specialized-turbo";
    tag = "v${version}";
    hash = "sha256-/h87J+8dJetz6aXDIyMqix+J4NspNIz74OfL/nEQWgg=";
  };

  build-system = with home-assistant.python.pkgs; [
    hatchling
  ];

  dependencies = with home-assistant.python.pkgs; [
    bleak
    cryptography
  ];

  pythonImportsCheck = [ "specialized_turbo" ];

  meta = {
    description = "Python library for communicating with Specialized Turbo e-bikes over Bluetooth Low Energy";
    homepage = "https://github.com/JamieMagee/specialized-turbo";
    changelog = "https://github.com/JamieMagee/specialized-turbo/releases/tag/v${version}";
    license = lib.licenses.mit;
  };
}
