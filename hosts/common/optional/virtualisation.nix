{
  pkgs,
  config,
  ...
}: {
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      runAsRoot = false;
      ovmf = {
        enable = true;
        packages = with pkgs; [OVMFFull.fd];
      };
      swtpm.enable = true;
    };
  };

  environment = {
    systemPackages = with pkgs; [swtpm virt-manager];
    etc = {
      "ovmf/edk2-x86_64-secure-code.fd" = {
        source = "${config.virtualisation.libvirtd.qemu.package}/share/qemu/edk2-x86_64-secure-code.fd";
      };

      "ovmf/edk2-i386-vars.fd" = {
        source = "${config.virtualisation.libvirtd.qemu.package}/share/qemu/edk2-i386-vars.fd";
        mode = "0644";
        user = "libvirtd";
      };
    };
  };

  programs.dconf.enable = true;
  users.users.jamie.extraGroups = ["libvirtd"];
}
