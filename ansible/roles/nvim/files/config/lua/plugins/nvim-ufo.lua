return {
    "kevinhwang91/nvim-ufo",
    dependencies = { "kevinhwang91/promise-async" },
    config = function()
      -- Recommended vim settings for UFO
      vim.o.foldcolumn = "1"      -- Show fold column
      vim.o.foldlevel = 99        -- Using ufo provider needs a large foldlevel
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true     -- Enable folding by default

      require("ufo").setup({
        -- Use LSP and indentation as fold providers
        provider_selector = function(bufnr, filetype, buftype)
          return {"lsp", "indent"}
        end
      })

      -- Optional global keymaps to open/close all folds quickly
      vim.keymap.set("n", "zR", require("ufo").openAllFolds)
      vim.keymap.set("n", "zM", require("ufo").closeAllFolds)
    end
  }
