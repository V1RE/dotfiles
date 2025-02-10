---@type LazyPluginSpec
return {
  "folke/edgy.nvim",
  event = "VeryLazy",
  init = function()
    vim.opt.laststatus = 3
    vim.opt.splitkeep = "screen"
  end,
  opts = {
    options = {
      left = { size = 40 },
    },
    bottom = {
      "Trouble",
      { ft = "qf", title = "QuickFix" },
      {
        ft = "help",
        size = { height = 20 },
        -- only show help buffers
        filter = function(buf)
          return vim.bo[buf].buftype == "help"
        end,
      },
    },
    -- left = {
    --   {
    --     title = " Files",
    --     ft = "neo-tree",
    --     filter = function(buf)
    --       return vim.b[buf].neo_tree_source == "filesystem"
    --     end,
    --     pinned = true,
    --   },
    --   {
    --     title = " Git",
    --     ft = "neo-tree",
    --     filter = function(buf)
    --       return vim.b[buf].neo_tree_source == "git_status"
    --     end,
    --     pinned = true,
    --     size = { height = 8 },
    --     open = "Neotree position=right git_status",
    --   },
    -- },
  },
}
