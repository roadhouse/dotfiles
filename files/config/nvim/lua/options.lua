local o = vim.opt
o.autoindent = true
o.foldenable = true
o.foldmethod = "expr"
o.foldexpr = "nvim_treesitter#foldexpr()"
o.foldlevel = 1
o.termguicolors = true
o.colorcolumn = '80'
o.cursorcolumn = true
o.expandtab = true
o.hlsearch = true
o.ignorecase = true
o.mouse = 'a'
o.number = true
o.relativenumber = true
o.scrolloff = 3
o.shiftwidth = 2
o.smartcase = true
o.tabstop = 2
o.backup = false
o.writebackup = false

-- to fix bug on treesitter not display folding, from here:
-- https://github.com/nvim-telescope/telescope.nvim/issues/699#issuecomment-1159637962
vim.api.nvim_create_autocmd({ "BufEnter" }, { pattern = { "*" }, command = "normal zx", })
