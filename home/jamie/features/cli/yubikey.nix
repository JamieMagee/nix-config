{pkgs, ...}: {
  home.packages = with pkgs; [
    yubikey-manager
    yubikey-personalization
  ];
  pam.yubico.authorizedYubiKeys.ids = [];
}
