{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
}:
stdenv.mkDerivation rec {
  pname = "par2cmdline-turbo";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "animetosho";
    repo = "par2cmdline-turbo";
    rev = "v${version}";
    hash = "sha512-CM7VQ6y9qXZrBnk9RonWvMs2UgRrY/E1KpNbpW+1Y44sMuIKcbLuvO6ejSxT1HPbxWa2CTiV5rZb1nrD/F0ttg==";
  };

  nativeBuildInputs = [ autoreconfHook ];

  meta = with lib; {
    homepage = "https://github.com/animetosho/par2cmdline-turbo";
    description = "par2cmdline × ParPar: speed focused par2cmdline fork ";
    license = licenses.gpl2Plus;
    platforms = platforms.all;
  };
}
