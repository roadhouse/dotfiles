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
  use {'nvim-tree/nvim-web-devicons'}
  use {'folke/tokyonight.nvim'}
  use {'nvim-lualine/lualine.nvim'}
  use {'alvan/vim-closetag'}
  use {'jiangmiao/auto-pairs'}
  use {'mileszs/ack.vim'}

  use {'scrooloose/nerdcommenter'}
  --use {'sheerun/vim-polyglot'}
  use {'tpope/vim-surround'}
  use {'dense-analysis/ale'}
  use {'numirias/semshi'}
  use {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "neovim/nvim-lspconfig",
}
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

