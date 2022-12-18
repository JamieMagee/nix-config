{
  stdenv,
  lib,
  fetchurl,
  dpkg,
  openjdk11,
  makeWrapper,
  ...
}:
stdenv.mkDerivation rec {
  pname = "microsoft-identity-broker";
  version = "1.4.1";

  src = fetchurl {
    url = "https://packages.microsoft.com/ubuntu/22.04/prod/pool/main/m/${pname}/${pname}_${version}_amd64.deb";
    hash = "sha512-d7eKqB9+OUr/B1ZMwX9T9PfbBn9KpUEmJcCe7LHOoMj1fsETDIjvLmXtzijGwVLhYc1JvjbJXEWoTw0oBb9cFQ==";
  };

  patches = [./execstartpre.patch];

  nativeBuildInputs = [dpkg makeWrapper];

  unpackCmd = ''
    mkdir -p root
    dpkg-deb -x $curSrc root
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/microsoft-identity-broker
    cp -a opt/microsoft/identity-broker/lib/* $out/lib/microsoft-identity-broker
    cp -a usr/* $out

    for jar in $out/lib/microsoft-identity-broker/*.jar; do
      classpath="$classpath:$jar"
    done

    mkdir -p $out/bin
    makeWrapper ${openjdk11}/bin/java $out/bin/microsoft-identity-broker \
      --add-flags "-classpath $classpath com.microsoft.identity.broker.service.IdentityBrokerService" \
      --add-flags "-verbose"
    makeWrapper ${openjdk11}/bin/java $out/bin/microsoft-identity-device-broker \
      --add-flags "-verbose" \
      --add-flags "-classpath $classpath" \
      --add-flags "com.microsoft.identity.broker.service.DeviceBrokerService" \
      --add-flags "save"

    runHook postInstall
  '';

  postInstall = ''
    substituteInPlace $out/lib/systemd/system/microsoft-identity-device-broker.service \
      --replace \
        ExecStart=/opt/microsoft/identity-broker/bin/microsoft-identity-device-broker \
        ExecStart=$out/bin/microsoft-identity-device-broker \
      --replace \
        /usr/lib/jvm/java-11-openjdk-amd64 \
        ${openjdk11}/bin/java
    substituteInPlace $out/lib/systemd/user/microsoft-identity-broker.service \
      --replace \
        ExecStart=/opt/microsoft/identity-broker/bin/microsoft-identity-broker \
        ExecStart=$out/bin/microsoft-identity-broker \
      --replace \
        /usr/lib/jvm/java-11-openjdk-amd64 \
        ${openjdk11}/bin/java
    substituteInPlace $out/share/dbus-1/system-services/com.microsoft.identity.devicebroker1.service \
      --replace \
        Exec=/opt/microsoft/identity-broker/bin/microsoft-identity-device-broker \
        Exec=$out/bin/microsoft-identity-device-broker
    substituteInPlace $out/share/dbus-1/services/com.microsoft.identity.broker1.service \
      --replace \
        Exec=/opt/microsoft/identity-broker/bin/microsoft-identity-broker \
        Exec=$out/bin/microsoft-identity-broker
  '';

  meta = with lib; {
    description = "Microsoft Authentication Library cross platform Dbus client for talking to microsoft-identity-broker";
    homepage = "https://www.microsoft.com/";
    license = licenses.unfree;
    platforms = ["x86_64-linux"];
    maintainers = with lib.maintainers; [jamiemagee];
  };
}
