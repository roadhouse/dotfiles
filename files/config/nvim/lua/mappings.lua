-- Comma as leader key
-- vim.g.mapleader = ','
vim.keymap.set("n", " ", "<Nop>", { silent = true, remap = false })
vim.g.mapleader = " "

local hush = { silent = true }

vim.keymap.set("v", "<return>", ":fold<CR>", hush)
vim.keymap.set("n", "<return>", "za", hush)

vim.keymap.set('n', '<DOWN>', '<C-W><C-J>')
vim.keymap.set('n', '<UP>', '<C-W><C-K>')
vim.keymap.set('n', '<RIGHT>', '<C-W><C-L>')
vim.keymap.set('n', '<LEFT>', '<C-W><C-H>')

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
-- vim.keymap.set('n', '<leader>fr', builtin.lsp_document_symbols, {})
vim.keymap.set('n', '<leader>fr', builtin.lsp_references, {})
vim.keymap.set('n', '<leader>fd', builtin.lsp_definitions, {})

-- Trouble
vim.keymap.set('n', '<leader>ft', ':TroubleToggle<cr>', {})

-- NvimTree
vim.keymap.set('n', '<leader>t', ':NvimTreeToggle<cr>', {})
vim.keymap.set('n', '<leader>st', ':NvimTreeFindFile<cr>', {})

-- Alias
vim.cmd("ab pry require 'pry'; binding.pry;")
