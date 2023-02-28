local mason = require('mason-lspconfig')
local lspconfig = require('lspconfig')

local langconf = {
  lua_ls = {
    Lua = {
      diagnostics = {
        globals = { "vim" },
      },
    },
  },
}

mason.setup({
  automatic_installation = true,
})
mason.setup_handlers({
  function(server)
    lspconfig[server].setup({
      settings = langconf[server]
    })
  end,
})
