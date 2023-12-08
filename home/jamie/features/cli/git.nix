{pkgs, ...}: {
  programs.git = {
    enable = true;
    package = pkgs.gitAndTools.gitFull;
    userName = "Jamie Magee";
    userEmail = "jamie.magee@gmail.com";
    aliases = {
      co = "checkout";
      cob = "checkout -b";

      tags = "tag -l";
      branches = "branch -a";
      remotes = "remote -v";

      amend = "commit -a --amend";

      lg = "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";

      whoami = "!sh -c 'echo \"$(git config --get user.name) <$(git config --get user.email)>\"'";
    };
    signing = {
      key = "key::sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIEfboykpOQU4syTfATJPL+CICYyZdVXOROU2O4iLmmA9AAAABHNzaDo= ";
      signByDefault = true;
    };
    difftastic = {
      enable = true;
    };
    extraConfig = {
      branch = {
        autosetuprebase = "always";
      };
      core = {
        autocrlf = "input";
        # https://git-scm.com/docs/git-config#Documentation/git-config.txt-corefsmonitor
        fsmonitor = true;
        safecrlf = false;
        untrackedCache = true;
      };
      feature = {
        # https://git-scm.com/docs/git-config#Documentation/git-config.txt-featuremanyFiles
        manyFiles = true;
      };
      format = {
        signOff = true;
      };
      gpg = {
        format = "ssh";
      };
      help = {
      	autocorrect = 1;
      };
      init = {
        defaultBranch = "main";
      };
      push = {
        # https://git-scm.com/docs/git-config#Documentation/git-config.txt-pushdefaultgit
        default = "current";
        gpgSign = "if-asked";
      };
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
    gitCredentialHelper = {
      enable = true;
    };
  };
}
