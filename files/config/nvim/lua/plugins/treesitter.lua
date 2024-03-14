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
      init_selection = '<C-space>',
      node_incremental = '<C-space>',
      scope_incremental = '<Tab>',
      node_decremental = '<S-Tab>',
    },
  },
  indent = {
    enable = true
  }
}
