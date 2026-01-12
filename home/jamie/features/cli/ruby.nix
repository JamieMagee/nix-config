{
  # pkgs.ruby doesn't play well with psych
  # Install ruby with mise instead
  programs = {
    mise = {
      enable = true;
      globalConfig = {
        tools = {
          ruby = [
            "3.4.8"
            "4.0.0"
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
