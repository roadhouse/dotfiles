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
  use {'nvim-tree/nvim-web-devicons'}
  use {'folke/tokyonight.nvim'}
  use({
    'nvim-lualine/lualine.nvim',
    config = function() require('plugins.lualine') end
  })
  use {'alvan/vim-closetag'}
  use {'jiangmiao/auto-pairs'}
  use {'mileszs/ack.vim'}
  use {'scrooloose/nerdcommenter'}
  use {'tpope/vim-surround'}
  use({
    'dense-analysis/ale',
    config = function() require('plugins.ale') end,
  })
  use {'numirias/semshi'}
  use ({
    "williamboman/mason.nvim",
    config = function() require('plugins.mason') end,
  })
  use ({
    "williamboman/mason-lspconfig.nvim",
    config = function() require('plugins.mason-lspconfig') end,
  })
  use ({
    'neovim/nvim-lspconfig',
  })
  use({
    'kevinhwang91/nvim-ufo',
    requires = 'kevinhwang91/promise-async',
    config = function() require('plugins.ufo') end,
  })
  use {'nvim-telescope/telescope.nvim', requires = 'nvim-lua/plenary.nvim'}
  use({
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    config = function() require('plugins.treesitter') end,
  })
  use({
    'mattn/gist-vim',
    requires = 'mattn/webapi-vim',
    config = function() require('plugins.gist') end,
  })
  use {'L3MON4D3/luasnip', requires = 'rafamadriz/friendly-snippets'}
  use({
    'hrsh7th/nvim-cmp',
    'saadparwaiz1/cmp_luasnip',
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-cmdline',
    'hrsh7th/cmp-nvim-lua',
    config = function() require('plugins.cmp') end,
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

