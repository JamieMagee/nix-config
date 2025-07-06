{ pkgs, ... }:
{
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
      format = "ssh";
      key = "key::sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIEfboykpOQU4syTfATJPL+CICYyZdVXOROU2O4iLmmA9AAAABHNzaDo= ";
      signByDefault = false;
    };
    difftastic = {
      enable = true;
    };
    extraConfig = {
      branch = {
        autosetuprebase = "always";
        sort = "-committerdate";
      };
      core = {
        autocrlf = "input";
        # https://git-scm.com/docs/git-config#Documentation/git-config.txt-corefsmonitor
        fsmonitor = true;
        safecrlf = false;
        untrackedCache = true;
      };
      fetch = {
        prune = true;
      };
      feature = {
        # https://git-scm.com/docs/git-config#Documentation/git-config.txt-featuremanyFiles
        # manyFiles = true;
      };
      format = {
        signOff = true;
      };
      help = {
        autocorrect = 10;
      };
      init = {
        defaultBranch = "main";
      };
      push = {
        # https://git-scm.com/docs/git-config#Documentation/git-config.txt-pushdefaultgit
        default = "current";
        gpgSign = "if-asked";
        autoSetupRemote = true;
      };
      pull = {
        rebase = true;
      };
      merge = {
        conflictStyle = "zdiff3";
      };
      rebase = {
        autosquash = true;
        autostash = true;
        updateRefs = true;
      };
      commit = {
        verbose = true;
      };
      rerere = {
        enabled = true;
      };
      diff = {
        algorithm = "histogram";
        submodule = "log";
      };
      status = {
        submoduleSummary = true;
      };
      submodule = {
        recurse = true;
      };
      log = {
        date = "iso-local";
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
