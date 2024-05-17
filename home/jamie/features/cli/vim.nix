{
  programs.nixvim = {
    enable = true;
    colorschemes = {
      nord.enable = true;
    };
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
    };
  };
}
