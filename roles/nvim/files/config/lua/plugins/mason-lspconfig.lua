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
        
        -- JavaScript/TypeScript
        'tsserver', 'eslint', 'biome', 'jsonls',
        
        -- Python
        'pyright', 'ruff_lsp', 'basedpyright', 'pylsp',
        
        -- Lua
        'lua_ls',
        
        -- Go
        'gopls',
        
        -- Rust
        'rust_analyzer',
        
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
        
        -- Vue
        'vuels',
        
        -- Ansible
        'ansiblels',
        
        -- Kubernetes
        'yamlls', 'helm_ls',
        
        -- GraphQL
        'graphql',
        
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
        
        tsserver = {
          typescript = {
            inlayHints = {
              includeInlayParameterNameHints = 'all',
              includeInlayParameterNameHintsWhenArgumentMatchesName = false,
              includeInlayFunctionParameterTypeHints = true,
              includeInlayVariableTypeHints = true,
              includeInlayPropertyDeclarationTypeHints = true,
              includeInlayFunctionLikeReturnTypeHints = true,
              includeInlayEnumMemberValueHints = true,
            },
          },
          javascript = {
            inlayHints = {
              includeInlayParameterNameHints = 'all',
              includeInlayParameterNameHintsWhenArgumentMatchesName = false,
              includeInlayFunctionParameterTypeHints = true,
              includeInlayVariableTypeHints = true,
              includeInlayPropertyDeclarationTypeHints = true,
              includeInlayFunctionLikeReturnTypeHints = true,
              includeInlayEnumMemberValueHints = true,
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
        
        rust_analyzer = {
          ['rust-analyzer'] = {
            checkOnSave = {
              command = "clippy",
            },
            cargo = {
              loadOutDirsFromCheck = true,
            },
            procMacro = {
              enable = true,
            },
          },
        },
        
        jsonls = {
          json = {
            schemas = require('schemastore').json.schemas(),
            validate = { enable = true },
          },
        },
        
        yamlls = {
          yaml = {
            schemas = require('schemastore').yaml.schemas(),
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
        
        eslint = {
          settings = {
            codeAction = {
              disableRuleComment = {
                enable = true,
                location = "separateLine",
              },
              showDocumentation = {
                enable = true,
              },
            },
            codeActionOnSave = {
              enable = false,
              mode = "all",
            },
            format = true,
            quiet = false,
            run = "onType",
            sourceType = "module",
          },
        },
      }

      -- Setup mason-lspconfig
      mason_lspconfig.setup({
        ensure_installed = servers,
        automatic_installation = true,
      })

      -- Setup handlers for each server
      mason_lspconfig.setup_handlers({
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
      })

      -- Custom commands for LSP management
      vim.api.nvim_create_user_command('LspInstallAll', function()
        for _, server in ipairs(servers) do
          vim.cmd('MasonInstall ' .. server)
        end
      end, { desc = 'Install all configured LSP servers' })

      vim.api.nvim_create_user_command('LspInfo', function()
        vim.cmd('LspInfo')
      end, { desc = 'Show LSP information' })
    end,
  },
}
