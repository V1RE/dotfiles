---@type LazyPluginSpec[]
return {
  {
    "alker0/chezmoi.vim",
    lazy = false,
    init = function()
      vim.g["chezmoi#use_tmp_buffer"] = true
    end,
  },
  {
    "xvzc/chezmoi.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function(_, opts)
      require("chezmoi").setup(opts)

      vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
        pattern = { os.getenv("HOME") .. "/.local/share/chezmoi/**" },
        callback = function()
          vim.schedule(require("chezmoi.commands.__edit").watch)
        end,
      })
    end,
  },
}
