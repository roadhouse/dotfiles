-- Comma as leader key
-- vim.g.mapleader = ','
vim.keymap.set("n", " ", "<Nop>", { silent = true, remap = false })
vim.g.mapleader = " "

local hush = { silent = true }
vim.keymap.set("v", "<return>", ":fold<CR>", hush)
vim.keymap.set("n", "<return>", "zA", hush)

-- Alt-j/k inserts blank line below/above
vim.keymap.set('n', '<A-j>', ':set paste<CR>m`o<Esc>``:set nopaste<CR>')
vim.keymap.set('n', '<A-k>', ':set paste<CR>m`O<Esc>``:set nopaste<CR>')

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
vim.keymap.set({'n', 'x'}, 'cv', '"+y')
vim.keymap.set({'n', 'x'}, 'cp', '"+p')

-- Telescope
vim.keymap.set('n', '<leader>fh', ':Telescope current_buffer_fuzzy_find<cr>', {})
vim.keymap.set('n', '<leader>ff', ':Telescope git_files<cr>', {})
vim.keymap.set('n', '<leader>FF', ':Telescope find_files<cr>', {})
vim.keymap.set('n', '<leader>fg', ':Telescope live_grep<cr>', {})
vim.keymap.set('n', '<leader>fb', ':Telescope buffers<cr>', {})
vim.keymap.set('n', '<leader>fm', ':Telescope lsp_document_symbols<cr>', {})
vim.keymap.set('n', '<leader>fr', ':Telescope lsp_references<cr>', {})
vim.keymap.set('n', '<leader>fd', ':Telescope lsp_definitions<cr>', {})

-- Trouble
vim.keymap.set('n', '<leader>ft', ':TroubleToggle<cr>', {})

-- ToggleTerm
vim.keymap.set('n', '<leader>t', ':ToggleTerm direction=float<cr>', {})

-- Alias
vim.cmd("ab pry require 'pry'; binding.pry;")
