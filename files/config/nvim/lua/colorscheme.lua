require("tokyonight").setup({
  style = "storm",
  transparent = true,
  terminal_colors = true,
  styles = {
    comments = { italic = true },
    keywords = { italic = true },
    functions = { italic = true },
    sidebars = "transparent",
    floats = "transparent",
  },
  hide_inactive_statusline = true,
  lualine_bold = true,
})

vim.cmd('colorscheme tokyonight')
--vim.cmd('highlight Normal ctermbg=NONE guibg=NONE')
--vim.cmd('highlight NonText ctermbg=NONE guibg=NONE')
