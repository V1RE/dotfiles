local copilot = require("copilot")

vim.defer_fn(function()
  ---@type copilot_config
  local opts = {
    copilot_node_command = "/Users/niels/.local/share/mise/installs/bun/latest/bin/bun",
    ---@type copilot_config_panel
    panel = { enabled = false },
    suggestion = { enabled = false },
  }
  copilot.setup(opts)
end, 1000)
