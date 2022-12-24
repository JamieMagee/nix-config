{pkgs, ...}: {
  programs.git = {
    enable = true;
    package = pkgs.gitAndTools.gitFull;
    userName = "Jamie Magee";
    userEmail = "jamie.magee@gmail.com";
    # signing = {
    #   key = "key::sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAILDsTqh0sg8miK75yvFofimTiktt9WTcqSq8FXSMMhtgAAAABHNzaDo=";
    #   signByDefault = true;
    # };
    difftastic = {
      enable = true;
    };
    extraConfig = {
      # commit.gpgsign = true;
      # gpg.format = "ssh";
      feature.manyFiles = true;
      init.defaultBranch = "main";
    };
    lfs = {
      enable = true;
    };
    includes = [
      {
        condition = "gitdir:~/work/";
        contents = {
          user.email = "jamagee@microsoft.com";
        };
      }
    ];
  };

  programs.gh = {
    enable = true;
    enableGitCredentialHelper = true;
  };
}
