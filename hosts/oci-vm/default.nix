{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix

    ../common/global
    ../common/users/jamie.nix
    
    ./services
  ];

  boot.cleanTmpDir = true;

  networking = {
    hostName = "oci-vm";
  };

  services.openssh.enable = true;
  users.users.root.openssh.authorizedKeys.keys = [''ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDH57uSNXku16/ki28yRbc5mRpRRUCcvBUIN4Ach7lo+tVusMyQhqpeO8a22QdcVW74giSXeKXhW5pq5gEKYonFvEoEoLkj+EAqWaLDc+JYIQxqZ7oCcLOE1iACIPyIPP6HVmJsyrHmkkS8Oqv4oDVMS7+ajEv7O9maCxq4QQVTIgZyeLkD8jFT969SDtXtJl+jr1bqQG+N8xjHFJYWTpkRaY8NUvhhIQqAhjmfn40ih1Zo2dgc4ziUyGwgN+OugSzlISbcbhMbz4jPdyS4cWlI7WrGH2xVuTYtWeeEZq9Z3kCc56XnZL75IRG0UWpmjNaQTyvFCUK0TSoMRG6XFqqD ssh-key-2024-02-03'' ];

  system.stateVersion = "23.11";
}