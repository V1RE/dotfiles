local copilot = require("copilot")

vim.defer_fn(function()
  copilot.setup({
    copilot_node_command = "/Users/niels/.local/share/rtx/installs/node/lts/bin/node",
    panel = {
      auto_refresh = true,
    },
  })
end, 1000)
