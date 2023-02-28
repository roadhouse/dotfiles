local mason = require('mason-lspconfig')
local lspconfig = require('lspconfig')
mason.setup({
  automatic_installation = true,
})
mason.setup_handlers({
  function(server)
    lspconfig[server].setup({})
  end,
})
