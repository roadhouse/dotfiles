local function ensure_packer()
  local install_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'

  if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    print('Installing packer...')
    local packer_url = 'https://github.com/wbthomason/packer.nvim'
    vim.fn.system({ 'git', 'clone', '--depth', '1', packer_url, install_path })
    print('Done.')

    vim.cmd('packadd packer.nvim')
    return true
  end

  return false
end


local install_plugins = ensure_packer()

require('packer').startup(function(use)
  use { 'wbthomason/packer.nvim' }
  use { 'akinsho/toggleterm.nvim', config = function() require('toggleterm').setup(); end }
  use {
    'Exafunction/codeium.vim',
    config = function ()
    vim.keymap.set('i', '<C-g>', function () return vim.fn['codeium#Accept']() end, { expr = true, silent = true })
    vim.keymap.set('i', '<c-;>', function() return vim.fn['codeium#CycleCompletions'](1) end, { expr = true, silent = true })
    vim.keymap.set('i', '<c-,>', function() return vim.fn['codeium#CycleCompletions'](-1) end, { expr = true, silent = true })
    vim.keymap.set('i', '<c-x>', function() return vim.fn['codeium#Clear']() end, { expr = true, silent = true })
  end
  }
  use { 'tpope/vim-fugitive' }
  use { 'nvim-tree/nvim-web-devicons' }
  use { 'airblade/vim-rooter' }
  use { 'folke/tokyonight.nvim' }
  use { 'alvan/vim-closetag' }
  use { 'jiangmiao/auto-pairs' }
  use { 'mileszs/ack.vim' }
  use { 'scrooloose/nerdcommenter', config = function() vim.g.NERDSpaceDelims = true; end }
  use { 'tpope/vim-surround' }
  use { 'tpope/vim-rbenv' }
  use { 'lukas-reineke/indent-blankline.nvim', config = function() require('ibl').setup() end }
  use {
    'nvim-tree/nvim-tree.lua',
    config = function() require('nvim-tree').setup() end
  }
  use {
    'lewis6991/gitsigns.nvim',
    config = function() require('plugins.gitsigns') end,
  }
  use({
    'brenoprata10/nvim-highlight-colors',
  })
  use({
    'nvim-lualine/lualine.nvim',
    config = function() require('plugins.lualine') end
  })
  use({
    'VonHeikemen/lsp-zero.nvim',
    config = function() require('plugins.lsp-zero') end
  })
  use({
    'williamboman/mason.nvim',
    config = function() require('plugins.mason') end,
  })
  use({
    'williamboman/mason-lspconfig.nvim', config = function() require('plugins.mason-lspconfig') end,
  })
  use({
    'neovim/nvim-lspconfig',
  })
  use {
    'mfussenegger/nvim-lint',
    config = function()
      require('lint').linters_by_ft = {
        ruby = { 'rubocop' },
        lua = { 'luacheck' }
      }
    end,
  }
  use {
    'mhartington/formatter.nvim',
  }
  use({
    'folke/trouble.nvim',
  })
  use({
    'anuvyklack/pretty-fold.nvim',
    config = function() require('plugins.pretty-fold') end,
  })
  use({
    'nvim-telescope/telescope.nvim',
    requires = 'nvim-lua/plenary.nvim'
  })
  use({
    'nvim-treesitter/nvim-treesitter',
    requires = {
      'nvim-treesitter/nvim-treesitter-textobjects'
    },
    run = ':TSUpdate',
    config = function() require('plugins.treesitter') end,
  })
  use({
    'mattn/gist-vim',
    requires = 'mattn/webapi-vim',
    config = function() require('plugins.gist') end,
  })
  use({
    'hrsh7th/nvim-cmp',
    requires = {
      'saadparwaiz1/cmp_luasnip',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-cmdline',
      'hrsh7th/cmp-nvim-lua',
      'L3MON4D3/luasnip',
      'rafamadriz/friendly-snippets'
    },
    config = function() require('plugins.cmp') end,
  })
  use({
    'rcarriga/nvim-notify',
    config = function() require('plugins.notify') end
  })

  use({
   'wakatime/vim-wakatime',
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

vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]])
