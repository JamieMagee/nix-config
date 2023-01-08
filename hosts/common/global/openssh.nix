{
  services = {
    openssh = {
      enable = true;
      ports = [2222];
      permitRootLogin = "no";
      passwordAuthentication = false;
    };
  };
  programs.ssh.startAgent = true;
}
