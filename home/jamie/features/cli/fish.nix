{ lib, config, ... }:
{
  programs.fish = {
    enable = true;
    shellAbbrs = {
      cat = "bat";
      ls = "eza";
      nano = "micro";

      n = "nix";
      nd = "nix develop -c $SHELL";
      ns = "nix shell";
      nsn = "nix shell nixpkgs#";
      nb = "nix build";
      nbn = "nix build nixpkgs#";
      nf = "nix flake";

      nr = "nixos-rebuild --flake .";
      nrs = "nixos-rebuild --flake . switch";
      snr = "sudo nixos-rebuild --flake .";
      snrs = "sudo nixos-rebuild --flake . switch";
      hm = "home-manager --flake .";
      hms = "home-manager --flake . switch";

      g = "git";
      gco = "git checkout";
      gcob = "git checkout -b";
      gf = "git fetch";
      gp = "git pull";
    };

    functions = {
      fish_greeting = "";
    };

    interactiveShellInit = lib.mkIf config.programs.zellij.enable ''
      if test "$TERM_PROGRAM" != "vscode"
        eval (${lib.getExe config.programs.zellij.package} setup --generate-auto-start fish | string collect)
      end
    '';

    shellInit = ''
      if string match -q "$TERM_PROGRAM" "vscode"; and command -q code-insiders
        . (code-insiders --locate-shell-integration-path fish)
      end
    '';
  };
}
