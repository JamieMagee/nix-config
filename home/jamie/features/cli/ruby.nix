{
  # pkgs.ruby doesn't play well with psych
  # Install ruby with mise instead
  programs = {
    mise = {
      enable = true;
      globalConfig = {
        tools = {
          ruby = [
            "4.0.5"
          ];
        };
        settings = {
          idiomatic_version_file_enable_tools = [ "ruby" ];
        };
      };
    };
    fish = {
      shellInit = ''
        fish_add_path ~/.local/share/mise/shims
      '';
    };
  };
}
