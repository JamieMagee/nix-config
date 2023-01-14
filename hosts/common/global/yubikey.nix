{
  security.pam.yubico = {
    enable = true;
    # https://upgrade.yubico.com/getapikey/
    id = "83324";
  };

  services.pcscd = {
    enable = true;
  };
}
