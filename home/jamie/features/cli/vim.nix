{
  programs.nixvim = {
    enable = true;
    colorschemes = {
      nord.enable = true;
    };
    # Nixvim has its own instance of nixpkgs
    nixpkgs.config.allowUnfree = true;
    plugins = {
      copilot-vim.enable = true;
      neogit.enable = true;
      neo-tree.enable = true;
      nix.enable = true;
      lsp = {
        enable = true;
        servers = {
          nixd = {
            enable = true;
          };
        };
      };
      web-devicons.enable = true;
    };
  };
}
