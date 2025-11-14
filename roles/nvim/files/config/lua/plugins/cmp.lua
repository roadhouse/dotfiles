local has_words_before = function()
  unpack = unpack or table.unpack
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
end

return {
  "hrsh7th/nvim-cmp",
  dependencies = {
    "saadparwaiz1/cmp_luasnip",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-cmdline",
    "hrsh7th/cmp-nvim-lua",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-calc",
    "hrsh7th/cmp-emoji",
    "L3MON4D3/luasnip",
    "rafamadriz/friendly-snippets",
    "onsails/lspkind.nvim",
  },
  config = function()
    local cmp = require('cmp')
    local lspkind = require('lspkind')
    local luasnip = require('luasnip')

    -- Load snippets from friendly-snippets
    require('luasnip.loaders.from_vscode').lazy_load()

    -- Configure luasnip
    luasnip.config.setup({
      region_check_events = 'InsertEnter',
      delete_check_events = 'InsertLeave',
    })

    cmp.setup({
      -- Enable LSP snippets
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },

      -- Completion sources with enhanced configuration
      sources = cmp.config.sources({
        { name = 'nvim_lsp', priority = 1000, max_item_count = 20 },
        { name = 'luasnip', priority = 750, max_item_count = 10 },
        { name = 'path', priority = 500, max_item_count = 15 },
        { name = 'nvim_lua', priority = 450, max_item_count = 10 },
      }, {
        { name = 'buffer', priority = 250, max_item_count = 10,
          option = {
            get_bufnrs = function()
              return vim.api.nvim_list_bufs()
            end
          }
        },
        { name = 'calc', priority = 200 },
        { name = 'emoji', priority = 150 },
      }),

      -- Window configuration for better UI
      window = {
        completion = {
          border = 'rounded',
          winhighlight = 'Normal:CmpPmenu,FloatBorder:CmpPmenuBorder,CursorLine:CmpSel,Search:None',
          scrollbar = false,
        },
        documentation = {
          border = 'rounded',
          winhighlight = 'Normal:CmpDoc,FloatBorder:CmpDocBorder,CursorLine:CmpDocSel,Search:None',
          max_width = 60,
          max_height = 20,
        },
      },

      -- Formatting with lspkind for better icons
      formatting = {
        fields = { 'kind', 'abbr', 'menu' },
        format = lspkind.cmp_format({
          mode = 'symbol_text',
          maxwidth = 50,
          ellipsis_char = '...',
          symbol_map = {
            Text = '󰉿',
            Method = '󰆧',
            Function = '󰊕',
            Constructor = '',
            Field = '󰜢',
            Variable = '󰀫',
            Class = '󰠱',
            Interface = '',
            Module = '',
            Property = '󰜢',
            Unit = '󰑭',
            Value = '󰎠',
            Enum = '',
            Keyword = '󰌋',
            Snippet = '',
            Color = '󰏘',
            File = '󰈙',
            Reference = '󰈇',
            Folder = '󰉋',
            EnumMember = '',
            Constant = '󰏿',
            Struct = '󰙅',
            Event = '',
            Operator = '󰆕',
            TypeParameter = '󰅲',
          },
          before = function(entry, vim_item)
            -- Add source information
            vim_item.menu = ({
              buffer = '[Buffer]',
              nvim_lsp = '[LSP]',
              luasnip = '[Snippet]',
              nvim_lua = '[Lua]',
              path = '[Path]',
              calc = '[Calc]',
              emoji = '[Emoji]',
            })[entry.source.name]
            return vim_item
          end,
        }),
      },

      -- Enhanced mapping configuration
      mapping = cmp.mapping.preset.insert({
        -- Confirm completion
        ['<CR>'] = cmp.mapping.confirm({
          behavior = cmp.ConfirmBehavior.Replace,
          select = true,
        }),

        -- Cancel completion
        ['<C-e>'] = cmp.mapping.abort(),

        -- Navigate completion menu
        ['<C-n>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
        ['<C-p>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
        ['<Down>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
        ['<Up>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),

        -- Scroll documentation window
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),

        -- Toggle completion
        ['<C-Space>'] = cmp.mapping.complete(),

        -- Snippet navigation
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
          elseif luasnip.locally_jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { 'i', 's' }),

        -- Jump to next/previous snippet placeholder
        ['<C-j>'] = cmp.mapping(function(fallback)
          if luasnip.locally_jumpable(1) then
            luasnip.jump(1)
          else
            fallback()
          end
        end, { 'i', 's' }),

        ['<C-k>'] = cmp.mapping(function(fallback)
          if luasnip.locally_jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { 'i', 's' }),
      }),

      -- Additional configuration
      experimental = {
        ghost_text = {
          hl_group = 'LspCodeLens',
        },
      },

      -- Performance optimizations
      performance = {
        debounce = 60,
        throttle = 30,
        fetching_timeout = 500,
        max_view_entries = 200,
      },

      -- Preselect first item
      preselect = cmp.PreselectMode.Item,

      -- Completion behavior
      completion = {
        completeopt = 'menu,menuone,noinsert',
        keyword_length = 1,
      },
    })

    -- Setup cmdline completion
    cmp.setup.cmdline('/', {
      mapping = cmp.mapping.preset.cmdline(),
      sources = {
        { name = 'buffer' }
      }
    })

    cmp.setup.cmdline(':', {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources({
        { name = 'path' }
      }, {
        { name = 'cmdline' }
      })
    })

    -- Custom commands for completion management
    vim.api.nvim_create_user_command('CmpToggle', function()
      local enabled = not cmp.get_config().enabled
      require('cmp').setup({ enabled = enabled })
      print('Completion ' .. (enabled and 'enabled' or 'disabled'))
    end, { desc = 'Toggle completion' })
  end
}
