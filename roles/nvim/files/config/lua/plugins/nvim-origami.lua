return {
  "chrisgrieser/nvim-origami",
  event = "VeryLazy",
  opts = {
    useLspFoldsWithTreesitterFallback = {
      enabled = true,
      foldmethodIfNeitherIsAvailable = "indent",
    },
    pauseFoldsOnSearch = true,
    foldtext = {
      enabled = true,
      padding = 2,
      lineCount = {
        template = " %d",
        hlgroup = "OrigamiFoldCount",
      },
      diagnosticsCount = true,
      gitsignsCount = true,
      disableOnFt = { "snacks_picker_input" },
    },
    autoFold = {
      enabled = false,
      kinds = { "comment", "imports" },
    },
    foldKeymaps = {
      setup = true,
      closeOnlyOnFirstColumn = false,
      scrollLeftOnCaret = false,
    },
  },
  config = function(_, opts)
    require("origami").setup(opts)

    local function apply_fold_highlights()
      vim.api.nvim_set_hl(0, "OrigamiFoldCount", { fg = "#7aa2f7", bg = "NONE", bold = true })
      vim.api.nvim_set_hl(0, "Folded", { fg = "#a9b1d6", bg = "NONE", italic = true })
      vim.api.nvim_set_hl(0, "FoldColumn", { fg = "#565f89", bg = "NONE" })
    end

    apply_fold_highlights()
    vim.api.nvim_create_autocmd("ColorScheme", {
      group = vim.api.nvim_create_augroup("user-fold-cosmetics", { clear = true }),
      callback = apply_fold_highlights,
    })
  end,
  init = function()
    vim.opt.foldlevel = 99
    vim.opt.foldlevelstart = 99
    vim.opt.foldcolumn = "1"
    vim.opt.fillchars:append({
      fold = " ",
      foldopen = "",
      foldclose = "",
      foldsep = " ",
    })
  end,
}
