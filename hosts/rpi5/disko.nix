{
  disko.devices = {
    disk = {
      nvme = {
        type = "disk";
        device = "/dev/nvme0n1";  # Typical NVMe device path for Pi 5
        content = {
          type = "gpt";
          partitions = {
            firmware = {
              size = "512M";
              type = "EF00";  # EFI system partition
              label = "firmware";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot/firmware";
                mountOptions = [ "defaults" ];
              };
            };
            root = {
              size = "100%";
              label = "nixos";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/";
                mountOptions = [ "defaults" ];
              };
            };
          };
        };
      };
    };
  };
}