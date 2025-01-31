{ pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    recyclarr
  ];
}