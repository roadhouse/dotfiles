return {
 "VonHeikemen/lsp-zero.nvim",
  opts = function()
    local lsp = require('lsp-zero').preset({})
    lsp.on_attach(function(client, bufnr)
      lsp.default_keymaps({buffer = bufnr})
    end)
    lsp.setup()
  end
}
