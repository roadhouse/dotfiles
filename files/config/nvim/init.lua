require("options")
vim.cmd("ab pry require 'pry'; binding.pry;")
require("mappings")
require("commands")
require("plugins")
require("colorscheme")


-- ========================================================kk================== --
-- ==                         PLUGIN CONFIGURATION                         == --
-- ========================================================================== --

---
-- lualine.nvim (statusline)
---
require('lualine').setup({
    options = {
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
-- Mason
--
require('mason').setup()
require("mason-lspconfig").setup {
    ensure_installed = { "lua_ls", "bashls", "solargraph" },
    automatic_installation = true,
}
require("mason-lspconfig").setup_handlers {
    -- The first entry (without a key) will be the default handler
    -- and will be called for each installed server that doesn't have
    -- a dedicated handler.
    function (server_name) -- default handler (optional)
        require("lspconfig")[server_name].setup {}
    end,
}

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
  ensure_installed = {'ruby', 'lua', 'vim', 'help', 'python', 'bash'},
  sync_install = false,
  auto_install = true,
}

---
-- UFO (folding)
---
local ufo = require('ufo')
ufo.setup {
  provider_selector = function(bufnr, filetype, buftype)
    return {'treesitter', 'indent'}
  end
}
vim.keymap.set('n', 'zR', ufo.openAllFolds)
vim.keymap.set('n', 'zM', ufo.closeAllFolds)

---
-- Telescope
---
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>fh', builtin.current_buffer_fuzzy_find, {})
vim.keymap.set('n', '<leader>ff', builtin.git_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fm', builtin.lsp_document_symbols, {})

require'nvim-web-devicons'.setup()
