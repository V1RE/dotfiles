---@type LazyPluginSpec[]
return {
  {
    "Lilja/vim-chezmoi",
    cond = function()
      return nil ~= vim.api.nvim_exec("args", true):find("chezmoi")
    end,
    init = function()
      vim.g.chezmoi = "enabled"
    end,
  },
  {
    "alker0/chezmoi.vim",
    event = "VeryLazy",
    cond = function()
      return nil ~= vim.api.nvim_exec("args", true):find("chezmoi")
    end,
  },
  {
    "xvzc/chezmoi.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function(_, opts)
      require("chezmoi").setup(opts)

      vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
        pattern = { os.getenv("HOME") .. "/.local/share/chezmoi/*" },
        callback = function()
          vim.schedule(require("chezmoi.commands.__edit").watch)
        end,
      })
    end,
  },
}
