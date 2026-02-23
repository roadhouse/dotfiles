return {
  "folke/tokyonight.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    require("tokyonight").setup({
      style = "storm",
      transparent = true,
      styles = {
        functions = { italic = true },
        sidebars = "transparent",
        floats = "transparent",
      },
      hide_inactive_statusline = true,
      lualine_bold = true,
      on_highlights = function(hl, c)
        hl.CmpPmenu = { fg = c.fg_dark, bg = "NONE" }
        hl.CmpPmenuBorder = { fg = c.border_highlight, bg = "NONE" }
        hl.CmpSel = { fg = c.bg_dark, bg = c.blue, bold = true }
        hl.CmpDocSel = { fg = c.bg_dark, bg = c.blue, bold = true }
        hl.CmpDoc = { fg = c.fg_dark, bg = "NONE" }
        hl.CmpDocBorder = { fg = c.border_highlight, bg = "NONE" }
      end,
    })
  end,
}
