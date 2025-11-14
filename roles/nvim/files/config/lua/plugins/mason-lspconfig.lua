return {
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup({
        ui = {
          border = "rounded",
          icons = {
            package_pending = " ",
            package_installed = "󰄳 ",
            package_uninstalled = "󰅖 ",
          },
        },
      })
    end
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      "neovim/nvim-lspconfig",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      local mason_lspconfig = require("mason-lspconfig")
      local lspconfig = require("lspconfig")
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- Enhanced language server configurations
      local servers = {
        -- Web Development
        'html', 'cssls', 'emmet_ls', 'tailwindcss', 'astro', 'svelte',
        
        -- Python
        'pyright', 'ruff', 'basedpyright', 'pylsp',
        
        -- Lua
        'lua_ls',
        
        -- Go
        'gopls',
        
        -- Ruby
        'rubocop', 'ruby_lsp', 'solargraph',
        
        -- PHP
        'intelephense', 'phpactor',
        
        -- Java
        'jdtls',
        
        -- C/C++
        'clangd',
        
        -- Shell
        'bashls',
        
        -- YAML
        'yamlls',
        
        -- Docker
        'dockerls', 'docker_compose_language_service',
        
        -- Terraform
        'terraformls',
        
        -- SQL
        'sqlls',
        
        -- Markdown
        'marksman',
        
        -- GraphQL
        'graphql',
        
        -- Ansible
        'ansiblels',
        
        -- Kubernetes
        'helm_ls',
        
        -- TOML
        'taplo',
        
        -- XML
        'lemminx',
      }

      -- Server-specific configurations
      local server_configs = {
        lua_ls = {
          Lua = {
            diagnostics = {
              globals = { 'vim' },
              disable = { 'lowercase-global' },
            },
            workspace = {
              checkThirdParty = false,
              library = {
                vim.env.VIMRUNTIME,
                "${3rd}/luv/library",
                "${3rd}/busted/library",
                "${3rd}/luacheck/library",
                "/path/to/your/custom/library",
              },
            },
            telemetry = { enable = false },
            completion = {
              callSnippet = "Replace",
            },
          },
        },
        
        pyright = {
          python = {
            analysis = {
              typeCheckingMode = "basic",
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
              diagnosticSeverityOverrides = {
                reportUnusedVariable = "warning",
                reportUnusedImport = "warning",
              },
            },
          },
        },
        
        gopls = {
          gopls = {
            gofumpt = true,
            codelenses = {
              gc_details = false,
              generate = true,
              regenerate_cgo = true,
              run_govulncheck = true,
              test = true,
              tidy = true,
              upgrade_dependency = true,
              vendor = true,
            },
            hints = {
              assignVariableTypes = true,
              compositeLiteralFields = true,
              compositeLiteralTypes = true,
              constantValues = true,
              functionTypeParameters = true,
              parameterNames = true,
              rangeVariableTypes = true,
            },
            staticcheck = true,
            usePlaceholders = true,
          },
        },
        
        jsonls = {
          json = {
            validate = { enable = true },
          },
        },
        
        yamlls = {
          yaml = {
            validate = true,
            completion = true,
          },
        },
        
        bashls = {
          filetypes = { 'sh', 'bash', 'zsh' },
        },
        
        html = {
          html = {
            format = {
              templating = true,
              wrapLineLength = 120,
              wrapAttributes = 'auto-aligned',
            },
          },
        },
        
        cssls = {
          css = {
            validate = true,
            lint = {
              unknownProperties = "warning",
            },
          },
        },
      }

      -- Setup mason-lspconfig with handlers
      mason_lspconfig.setup({
        ensure_installed = servers,
        automatic_installation = true,
        handlers = {
          function(server_name)
            local config = server_configs[server_name] or {}
            lspconfig[server_name].setup({
              capabilities = capabilities,
              settings = config.settings or config,
              filetypes = config.filetypes,
              root_dir = config.root_dir,
              single_file_support = config.single_file_support ~= false,
              on_attach = config.on_attach,
            })
          end,
        },
      })

      -- Custom commands for LSP management
      vim.api.nvim_create_user_command('LspInstallAll', function()
        for _, server in ipairs(servers) do
          vim.cmd('MasonInstall ' .. server)
        end
      end, { desc = 'Install all configured LSP servers' })
    end,
  },
}
