return {
  "nvim-treesitter/nvim-treesitter",
  dependencies = {
    "nvim-treesitter/nvim-treesitter-textobjects",
  },
  build = ":TSUpdate",
  opts = {
    ensure_installed = {'ruby', 'lua', 'vim', 'python', 'bash'},
    sync_install = false,
    auto_install = true,
    highlight = {
      enable = true,
    },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = '<C-t>',
        node_incremental = '<C-t>',
        scope_incremental = '<Tab>',
        node_decremental = '<S-Tab>',
      },
    },
    indent = {
      enable = true
    }
  }
}
