{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.services.intune;
in {
  options.services.intune = {
    enable = mkEnableOption "intune";

    identityBrokerPackage = mkOption {
      type = types.package;
      default = pkgs.microsoft-identity-broker;
      defaultText = literalExpression "pkgs.microsoft-identity-broker";
      description = mdDoc ''
        Which identity-broker package to use.
      '';
    };
  };

  config = mkIf cfg.enable {
    users.users.microsoft-identity-broker = {
      group = "microsoft-identity-broker";
      isSystemUser = true;
    };

    users.groups.microsoft-identity-broker = {};
    environment.systemPackages = [cfg.identityBrokerPackage];
    systemd.packages = [cfg.identityBrokerPackage];
    services.dbus.packages = [cfg.identityBrokerPackage];
  };

  meta = {
    maintainers = with maintainers; [JamieMagee];
  };
}
