return {
  "folke/which-key.nvim",
  optional = true,
  opts = {
    defaults = {
      ["<leader>l"] = { name = "+LSP" },
    },
  },
  config = function(_, opts)
    local wk = require("which-key")
    wk.setup(opts)
    
    -- LSP keymaps registration
    wk.register({
      ["<leader>l"] = {
        name = "+LSP",
        a = { "<cmd>lua vim.lsp.buf.code_action()<cr>", "Code Action" },
        d = { "<cmd>Telescope lsp_document_symbols<cr>", "Document Symbols" },
        D = { "<cmd>lua vim.lsp.buf.type_definition()<cr>", "Type Definition" },
        f = { "<cmd>lua vim.lsp.buf.format({async = true})<cr>", "Format" },
        i = { "<cmd>LspInfo<cr>", "LSP Info" },
        I = { "<cmd>LspInstallAll<cr>", "Install All LSPs" },
        r = { "<cmd>lua vim.lsp.buf.rename()<cr>", "Rename" },
        s = { "<cmd>Telescope lsp_workspace_symbols<cr>", "Workspace Symbols" },
        x = { "<cmd>cclose<cr>", "Close Quickfix" },
      },
      ["g"] = {
        name = "+Goto",
        D = { "<cmd>lua vim.lsp.buf.declaration()<cr>", "Declaration" },
        d = { "<cmd>lua vim.lsp.buf.definition()<cr>", "Definition" },
        i = { "<cmd>lua vim.lsp.buf.implementation()<cr>", "Implementation" },
        r = { "<cmd>Telescope lsp_references<cr>", "References" },
        o = { "<cmd>lua vim.lsp.buf.type_definition()<cr>", "Type Definition" },
      },
      ["["] = {
        d = { "<cmd>lua vim.diagnostic.goto_prev()<cr>", "Previous Diagnostic" },
      },
      ["]"] = {
        d = { "<cmd>lua vim.diagnostic.goto_next()<cr>", "Next Diagnostic" },
      },
    })
  end,
}
