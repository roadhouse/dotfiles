require'nvim-treesitter.configs'.setup {
  ensure_installed = {'ruby', 'lua', 'vim', 'python', 'bash'},
  sync_install = false,
  auto_install = true,
  highlight = {
    enable = true,
  },
}
