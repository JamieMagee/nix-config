# paho-mqtt 2.1.0's tests fail intermittently with KeyboardInterrupt, missing
# callbacks, or ConnectionResetError. Upstream fixed that in "Fix test races":
#
#   https://github.com/eclipse-paho/paho.mqtt.python/pull/934
#
# That PR won't apply to 2.1.0 on its own, since it builds on test fixes made
# after the release, so take every tests/ change between the tag and the merge
# commit instead. PR 931 is in there too, which is why this replaces the patch
# list nixpkgs carries rather than appending to it.
#
# Applied via pythonPackagesExtensions so home-assistant's Python package set
# picks it up too.
_final: prev: {
  pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
    (_pyfinal: pyprev: {
      paho-mqtt = pyprev.paho-mqtt.overrideAttrs (_old: {
        patches = [
          (prev.fetchpatch {
            name = "tests-fix-test-races.patch";
            # v2.1.0...b5d201a ("Fix test races")
            url = "https://github.com/eclipse-paho/paho.mqtt.python/compare/af64a4365c6ac5a7a4d339e7b00f44df91353b35...b5d201a74eff65a9c9eac5933417e3db1b4ff720.diff";
            includes = [ "tests/*" ];
            hash = "sha256-xobpW7cPkoaZ03VDQ3ZnAVYRcK7qOkFppC4bMES0luk=";
          })
        ];
      });
    })
  ];
}
