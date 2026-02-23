-- ========================================================================== --
-- ==                               COMMANDS                               == --
-- ========================================================================== --

local function unload_user_modules()
  local prefixes = { "options", "mappings", "commands", "config", "plugins" }

  for name, _ in pairs(package.loaded) do
    for _, prefix in ipairs(prefixes) do
      if name == prefix or name:match("^" .. prefix .. "%.") then
        package.loaded[name] = nil
        break
      end
    end
  end
end

vim.api.nvim_create_user_command("ReloadConfig", function()
  unload_user_modules()
  dofile(vim.env.MYVIMRC)
  vim.notify("Config reloaded", vim.log.levels.INFO)
end, { desc = "Reload Neovim config" })
