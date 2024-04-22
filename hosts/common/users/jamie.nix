{ pkgs, config, ... }:
{
  users.users.jamie = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = [
      "wheel"
      "networkmanager"
      "video"
    ];
    openssh.authorizedKeys.keys = [
      "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAILcVlek7bNIbXecoGz7IvqZWFd1FQJReULawc2yFNdXtAAAABHNzaDo="
      "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIJzX8m5ulb8Yh+mLQL1vqT1d9k0/Kjo6GvJJSRQxK9dxAAAABHNzaDo="
      "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIH9nPL5Z2gsdclYU43EjADaN4JmXMMTijxcv4cv7T7KtAAAABHNzaDo="
      "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIEfboykpOQU4syTfATJPL+CICYyZdVXOROU2O4iLmmA9AAAABHNzaDo="
    ];
  };
}
