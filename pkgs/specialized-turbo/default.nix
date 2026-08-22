{
  lib,
  home-assistant,
  fetchFromGitHub,
}:

home-assistant.python3Packages.buildPythonPackage rec {
  pname = "specialized-turbo";
  version = "0.7.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "JamieMagee";
    repo = "specialized-turbo";
    tag = "v${version}";
    hash = "sha256-DAMgTj5SQdI9/CU/lG8SFeVK4QyJxJVWN44cI3WQGvE=";
  };

  build-system = with home-assistant.python3Packages; [
    hatchling
  ];

  dependencies = with home-assistant.python3Packages; [
    bleak
    cryptography
  ];

  optional-dependencies = with home-assistant.python3Packages; {
    cloud = [ httpx ];
  };

  pythonImportsCheck = [ "specialized_turbo" ];

  meta = {
    description = "Python library for communicating with Specialized Turbo e-bikes over Bluetooth Low Energy";
    homepage = "https://github.com/JamieMagee/specialized-turbo";
    changelog = "https://github.com/JamieMagee/specialized-turbo/releases/tag/v${version}";
    license = lib.licenses.mit;
  };
}
