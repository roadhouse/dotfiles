return {
  {
    "mason-org/mason.nvim",
    opts = {
      ui = {
        border = "rounded",
        icons = {
          package_pending = "o",
          package_installed = "+",
          package_uninstalled = "-",
        },
      },
    },
  },
  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = {
      "mason-org/mason.nvim",
      "neovim/nvim-lspconfig",
    },
    config = function()
      local mason_lspconfig = require("mason-lspconfig")

      local servers = {
        -- Frontend / Web
        "html", "cssls", "emmet_ls", "tailwindcss", "astro", "svelte",
        "jsonls",

        -- Core languages
        "pyright", "ruff",
        "lua_ls",
        "gopls",
        "ruby_lsp",
        "intelephense",
        "clangd",

        -- Infra / DevOps
        "bashls",
        "yamlls",
        "dockerls", "docker_compose_language_service",
        "terraformls",
        "ansiblels",
        "helm_ls",
        "taplo",

        -- Data / Docs
        "marksman",
        "graphql",
      }

      local server_configs = {
        lua_ls = {
          settings = {
            Lua = {
              runtime = {
                version = "LuaJIT",
              },
              diagnostics = {
                globals = { "vim", "use", "describe", "it", "assert", "before_each", "after_each" },
                disable = { "lowercase-global", "undefined-global" },
              },
              workspace = {
                checkThirdParty = false,
                library = {
                  vim.env.VIMRUNTIME,
                  "${3rd}/luv/library",
                  "${3rd}/busted/library",
                },
                maxPreload = 100000,
                preloadFileSize = 10000,
              },
              telemetry = { enable = false },
              completion = {
                callSnippet = "Replace",
                keywordSnippet = "Replace",
              },
              hint = {
                enable = true,
                arrayIndex = "Disable",
                await = true,
                paramName = "Disable",
                paramType = true,
                semicolon = "Disable",
                setType = false,
              },
            },
          },
        },
        pyright = {
          settings = {
            python = {
              analysis = {
                typeCheckingMode = "basic",
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                autoImportCompletions = true,
                diagnosticSeverityOverrides = {
                  reportUnusedVariable = "warning",
                  reportUnusedImport = "warning",
                  reportMissingImports = "error",
                  reportMissingTypeStubs = "warning",
                },
              },
            },
          },
        },
        gopls = {
          settings = {
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
              analyses = {
                unusedparams = true,
                shadow = true,
              },
              staticcheck = true,
              usePlaceholders = true,
            },
          },
        },
        jsonls = {
          settings = {
            json = {
              validate = { enable = true },
            },
          },
        },
        yamlls = {
          filetypes = { "yaml", "yaml.docker-compose", "yaml.gitlab" },
        },
        bashls = {
          filetypes = { "sh", "bash", "zsh" },
        },
        html = {
          settings = {
            html = {
              format = {
                templating = true,
                wrapLineLength = 120,
                wrapAttributes = "auto-aligned",
              },
            },
          },
        },
        cssls = {
          settings = {
            css = {
              validate = true,
              lint = {
                unknownProperties = "warning",
              },
            },
          },
        },
        helm_ls = {
          filetypes = { "helm" },
          root_markers = { "Chart.yaml" },
        },
      }

      mason_lspconfig.setup({
        ensure_installed = servers,
        automatic_enable = false,
      })

      for _, server_name in ipairs(servers) do
        vim.lsp.config(server_name, server_configs[server_name] or {})
      end

      vim.lsp.enable(servers)

      vim.api.nvim_create_user_command("LspInstallAll", function()
        for _, server in ipairs(servers) do
          vim.cmd("MasonInstall " .. server)
        end
      end, { desc = "Install all configured LSP servers" })
    end,
  },
}
