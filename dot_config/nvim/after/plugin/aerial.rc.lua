local aerial = require("aerial")
-- Call the setup function to change the default behavior
aerial.setup({
  open_automatic = function(bufnr)
    return not aerial.was_closed() and aerial.num_symbols(bufnr) > 1
  end,
})
