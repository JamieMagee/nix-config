{
  boot.zfs.forceImportRoot = false;
  services.zfs = {
    trim = {
      enable = true;
    };
    autoScrub = {
      enable = true;
    };
  };
}
