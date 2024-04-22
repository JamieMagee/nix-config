{ pkgs, ... }:
{
  home.packages = with pkgs; [
    yubikey-manager
    yubikey-personalization
  ];
  pam.yubico.authorizedYubiKeys.ids = [
    # 673
    "cccccbegnvkk"
    # 672
    "cccccbegnvkj"
    # 664
    "cccccbegnvkc"
    # 522
    "cccccbegnvcd"
  ];
}
