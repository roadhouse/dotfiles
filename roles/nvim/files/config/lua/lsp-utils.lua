-- LSP Utility Functions
local M = {}

-- Function to format buffer with available formatters
function M.format_buffer()
  local bufnr = vim.api.nvim_get_current_buf()
  local clients = vim.lsp.get_active_clients({ bufnr = bufnr })

  if #clients == 0 then
    vim.notify("No LSP clients attached", vim.log.levels.WARN)
    return
  end

  local formatters = {}
  for _, client in ipairs(clients) do
    if client.supports_method("textDocument/formatting") then
      table.insert(formatters, client.name)
    end
  end

  if #formatters == 0 then
    vim.notify("No LSP formatter available", vim.log.levels.WARN)
    return
  end

  vim.lsp.buf.format({
    async = true,
    timeout_ms = 10000,
    on_success = function()
      vim.notify("Formatted with: " .. table.concat(formatters, ", "), vim.log.levels.INFO)
    end,
    on_error = function(err)
      vim.notify("Format error: " .. err, vim.log.levels.ERROR)
    end,
  })
end

-- Function to show all diagnostics in a floating window
function M.show_all_diagnostics()
  local bufnr = vim.api.nvim_get_current_buf()
  local diagnostics = vim.diagnostic.get(bufnr)

  if #diagnostics == 0 then
    vim.notify("No diagnostics found", vim.log.levels.INFO)
    return
  end

  local lines = {}
  local max_width = 0

  for _, diag in ipairs(diagnostics) do
    local line = string.format(
      "Line %d: %s [%s]",
      diag.lnum + 1,
      diag.message,
      diag.source or "LSP"
    )
    table.insert(lines, line)
    max_width = math.max(max_width, #line)
  end

  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.api.nvim_buf_set_option(buf, 'modifiable', false)

  local win = vim.api.nvim_open_win(buf, true, {
    relative = 'cursor',
    width = math.min(max_width + 2, 80),
    height = math.min(#lines, 20),
    col = 0,
    row = 1,
    border = 'rounded',
    style = 'minimal',
  })

  vim.api.nvim_win_set_option(win, 'wrap', false)
  vim.api.nvim_win_set_option(win, 'cursorline', true)

  -- Close on escape or q
  local opts = { buffer = buf, silent = true }
  vim.keymap.set('n', '<Esc>', function() vim.api.nvim_win_close(win, true) end, opts)
  vim.keymap.set('n', 'q', function() vim.api.nvim_win_close(win, true) end, opts)
end

-- Function to restart LSP clients
function M.restart_lsp()
  local bufnr = vim.api.nvim_get_current_buf()
  local clients = vim.lsp.get_active_clients({ bufnr = bufnr })

  if #clients == 0 then
    vim.notify("No LSP clients to restart", vim.log.levels.WARN)
    return
  end

  local client_names = {}
  for _, client in ipairs(clients) do
    table.insert(client_names, client.name)
    client.stop()
  end

  -- Schedule restart after a short delay
  vim.defer_fn(function()
    vim.cmd("edit")
    vim.notify("Restarted LSP clients: " .. table.concat(client_names, ", "), vim.log.levels.INFO)
  end, 100)
end

-- Function to toggle inlay hints
function M.toggle_inlay_hints()
  local bufnr = vim.api.nvim_get_current_buf()
  local current = vim.lsp.inlay_hint.is_enabled(bufnr)
  vim.lsp.inlay_hint.enable(bufnr, not current)
  vim.notify("Inlay hints " .. (not current and "enabled" or "disabled"), vim.log.levels.INFO)
end

-- Function to list all LSP servers for current buffer
function M.list_lsp_servers()
  local bufnr = vim.api.nvim_get_current_buf()
  local clients = vim.lsp.get_active_clients({ bufnr = bufnr })

  if #clients == 0 then
    vim.notify("No LSP clients attached", vim.log.levels.INFO)
    return
  end

  local lines = { "LSP Servers for current buffer:" }
  for _, client in ipairs(clients) do
    local capabilities = {}
    if client.supports_method("textDocument/completion") then
      table.insert(capabilities, "completion")
    end
    if client.supports_method("textDocument/formatting") then
      table.insert(capabilities, "formatting")
    end
    if client.supports_method("textDocument/rename") then
      table.insert(capabilities, "rename")
    end
    if client.supports_method("textDocument/codeAction") then
      table.insert(capabilities, "codeAction")
    end

    table.insert(lines, string.format("  • %s (%s)", client.name, table.concat(capabilities, ", ")))
  end

  vim.notify(table.concat(lines, "\n"), vim.log.levels.INFO)
end

-- Function to get workspace folders
function M.get_workspace_folders()
  local folders = vim.lsp.buf.list_workspace_folders()
  if #folders == 0 then
    vim.notify("No workspace folders", vim.log.levels.INFO)
  else
    vim.notify("Workspace folders:\n" .. table.concat(folders, "\n"), vim.log.levels.INFO)
  end
end

-- Function to add workspace folder
function M.add_workspace_folder()
  local folder = vim.fn.input("Workspace folder path: ")
  if folder ~= "" then
    vim.lsp.buf.add_workspace_folder(folder)
    vim.notify("Added workspace folder: " .. folder, vim.log.levels.INFO)
  end
end

-- Function to remove workspace folder
function M.remove_workspace_folder()
  local folders = vim.lsp.buf.list_workspace_folders()
  if #folders == 0 then
    vim.notify("No workspace folders to remove", vim.log.levels.WARN)
    return
  end

  vim.ui.select(folders, {
    prompt = "Select workspace folder to remove:",
  }, function(choice)
    if choice then
      vim.lsp.buf.remove_workspace_folder(choice)
      vim.notify("Removed workspace folder: " .. choice, vim.log.levels.INFO)
    end
  end)
end

-- Create user commands
function M.setup_commands()
  vim.api.nvim_create_user_command('LspFormat', M.format_buffer, { desc = 'Format buffer with LSP' })
  vim.api.nvim_create_user_command('LspDiagnostics', M.show_all_diagnostics, { desc = 'Show all diagnostics' })
  vim.api.nvim_create_user_command('LspRestart', M.restart_lsp, { desc = 'Restart LSP clients' })
  vim.api.nvim_create_user_command('LspToggleInlayHints', M.toggle_inlay_hints, { desc = 'Toggle inlay hints' })
  vim.api.nvim_create_user_command('LspServers', M.list_lsp_servers, { desc = 'List LSP servers' })
  vim.api.nvim_create_user_command('LspWorkspaceFolders', M.get_workspace_folders, { desc = 'Show workspace folders' })
  vim.api.nvim_create_user_command('LspAddWorkspaceFolder', M.add_workspace_folder, { desc = 'Add workspace folder' })
  vim.api.nvim_create_user_command('LspRemoveWorkspaceFolder', M.remove_workspace_folder, { desc = 'Remove workspace folder' })
end

-- Auto-load the commands
M.setup_commands()

return M
