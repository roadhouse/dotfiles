return {
  "mattn/gist-vim",
  dependencies = { "mattn/webapi-vim" },
  config = function()
    vim.g.gist_open_browser_after_post = 1
    vim.g.gist_post_private = 1
  end
}
