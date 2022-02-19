local fn = vim.fn
-- Automatically install packer
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
    PACKER_BOOTSTRAP = fn.system({
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
    })
    print("Installing packer close and reopen Neovim...")
    vim.cmd([[packadd packer.nvim]])
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost fplugins.lua source <afile> | PackerSync
  augroup end
]])

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
    return
end

-- Have packer use a popup window
packer.init({
  display = {
    open_fn = function()
        return require("packer.util").float({ border = "rounded" })
    end,
  },
})

-- Install your plugins here
return packer.startup(function(use)
    -- My plugins here
    use("wbthomason/packer.nvim")
    use("nvim-lua/popup.nvim")
    use("nvim-lua/plenary.nvim")

    use("wakatime/vim-wakatime")

    use({
    "phaazon/hop.nvim",
    config = require("config.hop"),
    })

    use({
    "windwp/nvim-autopairs",
    config = require("config.autopairs"),
    })

    use({
    "numToStr/Comment.nvim",
    config = require("config.comment"),
    })

    use("kyazdani42/nvim-web-devicons")

    use({
    "kyazdani42/nvim-tree.lua",
    config = require("config.nvim-tree"),
    })

    use({
    "akinsho/bufferline.nvim",
    config = require("config.bufferline"),
    })

    use("moll/vim-bbye")

    use({
    "nvim-lualine/lualine.nvim",
    config = require("config.lualine"),
    })

    use({
    "akinsho/toggleterm.nvim",
    config = require("config.toggleterm"),
    })

    use({
    "ahmedkhalf/project.nvim",
    config = require("config.project"),
    })

    use("lewis6991/impatient.nvim")

    use({
    "lukas-reineke/indent-blankline.nvim",
    config = require("config.indentline"),
    })

    use("antoinemadec/FixCursorHold.nvim")
    use("christoomey/vim-tmux-navigator")

    use({
    "goolord/alpha-nvim",
    config = require("config.alpha"),
    })

    -- Colorschemes
    --use("lunarvim/darkplus.nvim")
    --use("lunarvim/onedarker.nvim")
    --use("EdenEast/nightfox.nvim")
    use({
    "catppuccin/nvim",
    as = "catppuccin",
    config = require("config.catppuccin"),
    })

    -- cmp plugins
    use({
    "hrsh7th/nvim-cmp",
    requires = {
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = require("config.cmp"),
    })

    -- snippets
    use("L3MON4D3/LuaSnip")
    use("rafamadriz/friendly-snippets")

    -- LSP

    use({
    "neovim/nvim-lspconfig",
    config = require("config.lsp"),
    })

    use({
    "williamboman/nvim-lsp-installer",
    })

    use("tamago324/nlsp-settings.nvim")

    use({
    "jose-elias-alvarez/null-ls.nvim",
    })

    use({
    "ray-x/lsp_signature.nvim",
    config = require("config.signature"),
    })

    -- Telescope
    use({
    "nvim-telescope/telescope.nvim",
    config = require("config.telescope"),
    })

    -- Treesitter
    use({
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate",
    config = require("config.treesitter"),
    })
    use("JoosepAlviste/nvim-ts-context-commentstring")
    use("windwp/nvim-ts-autotag")

    -- Git
    use({
    "lewis6991/gitsigns.nvim",
    config = require("config.gitsigns"),
    })

    use({
    "folke/which-key.nvim",
    config = require("config.whichkey"),
    })

    use({
    "ray-x/navigator.lua",
    requires = {
      "ray-x/guihua.lua",
      run = "cd lua/fzy && make",
    },
    config = require("config.navigator"),
    })
    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if PACKER_BOOTSTRAP then
        require("packer").sync()
    end
end)
