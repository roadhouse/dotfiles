return {
  "folke/tokyonight.nvim",
  lazy = false,
  priority = 1000,
  opts = {
    style = "storm",
    transparent = true,
    styles = {
      functions = { italic = true },
      sidebars = "transparent",
      floats = "transparent",
    },
    hide_inactive_statusline = true,
    lualine_bold = true,
  },
}
