require('lspconfig').setup({
  settings = {
    gopls = {
      analyses = {
        unusedparams = true,
      },
      completeUnimported = true,
      gofumpt = true,
      staticcheck = true,
      usePlaceholders = true
    },
  },
})
