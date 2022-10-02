local aerial = require("aerial")
-- Call the setup function to change the default behavior
aerial.setup({
  open_automatic = function()
    return not aerial.was_closed()
  end,
})
