{ ... }:
{
  disko.devices = {
    disk = {
      nvme = {
        type = "disk";
        device = "/dev/disk/by-id/nvme-eui.002538b921400e02";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              size = "1G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
              };
            };
            zfs = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "zroot";
              };
            };
          };
        };
      };

      raid-disk-1 = {
        type = "disk";
        device = "/dev/disk/by-id/ata-ST22000NM001E-3HM103_ZX20FEG2";
        content = {
          type = "gpt";
          partitions = {
            zfs = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "tank";
              };
            };
          };
        };
      };

      raid-disk-2 = {
        type = "disk";
        device = "/dev/disk/by-id/ata-ST22000NM001E-3HM103_ZX20FENF";
        content = {
          type = "gpt";
          partitions = {
            zfs = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "tank";
              };
            };
          };
        };
      };

      raid-disk-3 = {
        type = "disk";
        device = "/dev/disk/by-id/ata-ST22000NM001E-3HM103_ZX20LCF6";
        content = {
          type = "gpt";
          partitions = {
            zfs = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "tank";
              };
            };
          };
        };
      };

      raid-disk-4 = {
        type = "disk";
        device = "/dev/disk/by-id/ata-ST22000NM001E-3HM103_ZX20LCFJ";
        content = {
          type = "gpt";
          partitions = {
            zfs = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "tank";
              };
            };
          };
        };
      };

      raid-disk-5 = {
        type = "disk";
        device = "/dev/disk/by-id/ata-ST22000NM001E-3HM103_ZX20LRWJ";
        content = {
          type = "gpt";
          partitions = {
            zfs = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "tank";
              };
            };
          };
        };
      };
    };
    zpool = {
      zroot = {
        type = "zpool";
        mountpoint = null;
        rootFsOptions = {
          atime = "off";
          compression = "zstd";
        };
        datasets = {
          root = {
            type = "zfs_fs";
            mountpoint = "/";
          };
          nix = {
            type = "zfs_fs";
            mountpoint = "/nix";
          };
          home = {
            type = "zfs_fs";
            mountpoint = "/home";
          };
        };
      };

      tank = {
        type = "zpool";
        mode = "raidz";
        mountpoint = null;
        rootFsOptions = {
          atime = "off";
          compression = "zstd";
        };
        datasets = {
          root = {
            type = "zfs_fs";
            mountpoint = "/mnt/data";
          };
        };
      };
    };
  };
}
