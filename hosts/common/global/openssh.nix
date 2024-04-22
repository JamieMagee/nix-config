{
  services = {
    openssh = {
      enable = true;
      ports = [ 2222 ];
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = false;
      };
    };
  };
  programs.ssh.startAgent = true;
}
