-- Comma as leader key
vim.g.mapleader = ','

-- Activate command mode using ';' (less typing)
vim.keymap.set('n', ';', ':',{})
vim.keymap.set('n', ':', ';',{})

-- Shortcuts
vim.keymap.set('n','<leader>l', ':e#<cr>')
vim.keymap.set('n', '<leader>a', ':keepjumps normal! ggVG<cr>')

-- Basic clipboard interaction
vim.keymap.set({'n', 'x'}, 'cp', '"+y')
vim.keymap.set({'n', 'x'}, 'cv', '"+p')

-- Telescope
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>fh', builtin.current_buffer_fuzzy_find, {})
vim.keymap.set('n', '<leader>ff', builtin.git_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fm', builtin.lsp_document_symbols, {})

-- Alias
vim.cmd("ab pry require 'pry'; binding.pry;")
