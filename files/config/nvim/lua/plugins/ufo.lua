local ufo = require('ufo')
ufo.setup {
  provider_selector = function(bufnr, filetype, buftype)
    return {'treesitter', 'indent'}
  end
}
