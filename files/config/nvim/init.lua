-- ========================================================================== --
-- ==                           EDITOR SETTINGS                            == --
-- ========================================================================== --

--vim.opt.breakindent = true
vim.opt.colorcolumn = '80'
vim.opt.cursorcolumn = true
vim.opt.expandtab = true
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.foldenable = true
vim.opt.hlsearch = true
vim.opt.ignorecase = true
vim.opt.mouse = 'a'
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.scrolloff = 3
vim.opt.shiftwidth = 2
vim.opt.smartcase = true
vim.opt.tabstop = 2

vim.cmd("ab pry require 'pry'; binding.pry;")

-- ========================================================================== --
-- ==                             KEYBINDINGS                              == --
-- ========================================================================== --

-- Mappings
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

-- Telescope
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fm', builtin.lsp_document_symbols, {})

-- UFO (folding)
vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)

-- ========================================================================== --
-- ==                               COMMANDS                               == --
-- ========================================================================== --

vim.api.nvim_create_user_command('ReloadConfig','source $MYVIMRC | PackerCompile',{})

-- ========================================================================== --
-- ==                               PLUGINS                                == --
-- ========================================================================== --

local function ensure_packer()
  local install_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'

  if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    print('Installing packer...')
    local packer_url = 'https://github.com/wbthomason/packer.nvim'
    vim.fn.system({'git', 'clone', '--depth', '1', packer_url, install_path})
    print('Done.')

    vim.cmd('packadd packer.nvim')
    return true
  end

  return false
end

local install_plugins = ensure_packer()

require('packer').startup(function(use)
  use {'wbthomason/packer.nvim'}
  use {'cschlueter/vim-wombat'}
  use {'nvim-lualine/lualine.nvim'}
  use {'alvan/vim-closetag'}
  use {'jiangmiao/auto-pairs'}
  use {'mileszs/ack.vim'}
  use {'scrooloose/nerdcommenter'}
  use {'sheerun/vim-polyglot'}
  use {'tpope/vim-surround'}
  use {'dense-analysis/ale'}
  use {'numirias/semshi'}
  use {'neovim/nvim-lspconfig'}
  use {'kevinhwang91/nvim-ufo', requires = 'kevinhwang91/promise-async'}
  use {'nvim-telescope/telescope.nvim', requires = 'nvim-lua/plenary.nvim'}
  use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'}
  use {'mattn/gist-vim', requires = 'mattn/webapi-vim'}
  use {'L3MON4D3/luasnip', requires = 'rafamadriz/friendly-snippets'}
  use({
    'hrsh7th/nvim-cmp',
    'saadparwaiz1/cmp_luasnip',
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-cmdline',
    'hrsh7th/cmp-nvim-lua',
  })

  if install_plugins then
    require('packer').sync()
  end
end)

if install_plugins then
  print '=================================='
  print '    Plugins will be installed.'
  print '      After you press Enter'
  print '    Wait until Packer completes,'
  print '       then restart nvim'
  print '=================================='
  return
end

---
-- Colorscheme
---
vim.cmd('colorscheme wombat256')
vim.cmd('highlight Normal ctermbg=NONE guibg=NONE')
vim.cmd('highlight NonText ctermbg=NONE guibg=NONE')

-- ========================================================================== --
-- ==                         PLUGIN CONFIGURATION                         == --
-- ========================================================================== --

---
-- lualine.nvim (statusline)
---
require('lualine').setup({
    options = {
      icons_enabled = false,
      component_separators = '|',
      section_separators = '',
    },
  })

---
-- cmp.nvim (code completion/snippets)
---
local has_words_before = function()
  unpack = unpack or table.unpack
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
end
local luasnip = require('luasnip')
local cmp = require('cmp')
cmp.setup({
  mapping = cmp.mapping.preset.insert({
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_locally_jumpable() then
        luasnip.expand_or_jump()
      elseif has_words_before() then
        cmp.complete()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' })
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'buffer' },
  })
})

---
-- luasnip.nvim (snippets)
---
require('luasnip.loaders.from_vscode').lazy_load()

---
-- language server
---
local servers = {'solargraph', 'jedi_language_server'}
local lspconfig = require('lspconfig')
local capabilities = require('cmp_nvim_lsp').default_capabilities()
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    capabilities = capabilities,
  }
end

---
-- ALE
---
vim.g.ale_fix_on_save = 1
vim.g.ale_fixers = {
  [ 'ruby' ] = 'rubocop'
}

---
-- Gist
---
vim.g.gist_open_browser_after_post = 1
vim.g.gist_post_private = 1

---
-- TreeSitter (syntax tree)
---
require'nvim-treesitter.configs'.setup {
  ensure_installed = {'ruby', 'lua', 'vim', 'help', 'python'},
  sync_install = false,
  auto_install = true,
}

---
-- UFO (folding)
---
require('ufo').setup {
  provider_selector = function(bufnr, filetype, buftype)
    return {'treesitter', 'indent'}
  end
}
