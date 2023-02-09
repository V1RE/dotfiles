local copilot = require("copilot")

vim.defer_fn(function()
  copilot.setup({
    copilot_node_command = "/Users/niels/.volta/bin/node",
    panel = {
      auto_refresh = true,
    },
  })
end, 1000)
