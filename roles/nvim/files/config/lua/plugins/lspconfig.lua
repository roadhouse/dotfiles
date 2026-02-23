return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
  },
  config = function()
    local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
    if has_cmp then
      vim.lsp.config("*", {
        capabilities = cmp_nvim_lsp.default_capabilities(),
      })
    end

    vim.diagnostic.config({
      virtual_text = {
        prefix = "■",
        spacing = 2,
      },
      signs = true,
      underline = true,
      update_in_insert = false,
      severity_sort = true,
      float = {
        border = "rounded",
      },
    })

    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("user-lsp-keymaps", { clear = true }),
      callback = function(event)
        local bufnr = event.buf

        local map = function(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, {
            buffer = bufnr,
            remap = false,
            silent = true,
            desc = desc,
          })
        end

        map("n", "gd", vim.lsp.buf.definition, "LSP: Definition")
        map("n", "gD", vim.lsp.buf.declaration, "LSP: Declaration")
        map("n", "<leader>f", function()
          vim.lsp.buf.format({ async = true, timeout_ms = 10000 })
        end, "LSP: Format")
        map("n", "<leader>e", vim.diagnostic.open_float, "LSP: Line Diagnostics")
        map("n", "<leader>q", vim.diagnostic.setloclist, "LSP: Diagnostics to Loclist")
        map("n", "[d", function()
          vim.diagnostic.jump({ count = -1, float = true })
        end, "LSP: Previous Diagnostic")
        map("n", "]d", function()
          vim.diagnostic.jump({ count = 1, float = true })
        end, "LSP: Next Diagnostic")
      end,
    })
  end
}
