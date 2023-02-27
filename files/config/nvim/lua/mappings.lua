-- ========================================================================== --
-- ==                             KEYBINDINGS                              == --
-- ========================================================================== --
vim.keymap.set('n', ';', ':',{})
vim.keymap.set('n', ':', ';',{})
vim.keymap.set('n','<leader>l', ':e#<cr>')
-- Space as leader key
vim.g.mapleader = ','
-- Shortcuts
vim.keymap.set('n', '<leader>a', ':keepjumps normal! ggVG<cr>')
-- Basic clipboard interaction
vim.keymap.set({'n', 'x'}, 'cp', '"+y')
vim.keymap.set({'n', 'x'}, 'cv', '"+p')
