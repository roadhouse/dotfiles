local mason = require('mason-lspconfig')
local lspconfig = require('lspconfig')
local capabilities = require('cmp_nvim_lsp').default_capabilities()
--local on_attach = require("lsp-format").on_attach

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
      settings = langconf[server],
      capabilities = capabilities,
      --on_attach = on_attach
    })
  end,
})
