local copilot = require("copilot")

vim.defer_fn(function()
  copilot.setup({
    copilot_node_command = "/Users/niels/.volta/tools/image/node/16.17.0/bin/node",
  })
end, 100)
