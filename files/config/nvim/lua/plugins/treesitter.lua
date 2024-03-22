require'nvim-treesitter.configs'.setup {
  ensure_installed = {'ruby', 'lua', 'vim', 'python', 'bash'},
  sync_install = false,
  auto_install = true,
  highlight = {
    enable = true,
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = '<C-y>',
      node_incremental = '<C-y>',
      scope_incremental = '<Tab>',
      node_decremental = '<S-Tab>',
    },
  },
  indent = {
    enable = true
  }
}
