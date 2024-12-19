---@type LazyPluginSpec[]
local M = {
  {
    "echasnovski/mini.icons",
    lazy = true,

    opts = {
      file = {
        [".keep"] = { glyph = "󰊢", hl = "MiniIconsGrey" },
        ["devcontainer.json"] = { glyph = "", hl = "MiniIconsAzure" },
        [".eslintrc.js"] = { glyph = "󰱺", hl = "MiniIconsYellow" },
        [".node-version"] = { glyph = "", hl = "MiniIconsGreen" },
        -- Prettier
        [".prettierrc"] = { glyph = "", hl = "MiniIconsPurple" },
        [".prettierignore"] = { glyph = "", hl = "MiniIconsPurple" },

        -- ESLint
        ["eslint.config.js"] = { glyph = "", hl = "MiniIconsYellow" },
        ["eslint.config.mjs"] = { glyph = "", hl = "MiniIconsYellow" },

        ["package.json"] = { glyph = "", hl = "MiniIconsGreen" },
        ["package-lock.json"] = { glyph = "", hl = "MiniIconsRed" },

        ["tsconfig.json"] = { glyph = "", hl = "MiniIconsAzure" },
        ["tsconfig.build.json"] = { glyph = "", hl = "MiniIconsAzure" },
        -- Yarn
        ["yarn.lock"] = { glyph = "", hl = "MiniIconsBlue" },
        [".yarnrc.yml"] = { glyph = "", hl = "MiniIconsBlue" },
        -- Next
        ["next.config.ts"] = { glyph = "", hl = "MiniIconsAzure" },
        ["next.config.js"] = { glyph = "", hl = "MiniIconsAzure" },
        ["next.config.mjs"] = { glyph = "", hl = "MiniIconsAzure" },
        -- Bun
        ["bun.lockb"] = { glyph = "" },
        ["bunfig.toml"] = { glyph = "" },
        [".babelrc"] = { glyph = "", hl = "MiniIconsYellow" },
        ["vite.config.ts"] = { glyph = "󰹭", hl = "MiniIconsYellow" },
        ["vite.config.js"] = { glyph = "󰹭", hl = "MiniIconsYellow" },
        ["tailwind.config.js"] = { glyph = "󱏿", hl = "MiniIconsBlue" },
        ["tailwind.config.ts"] = { glyph = "󱏿", hl = "MiniIconsBlue" },

        ["metro.config.js"] = { glyph = "", hl = "MiniIconsPurple" },
        ["babel.config.js"] = { glyph = "", hl = "MiniIconsYellow" },
        ["webpack.config.js"] = { glyph = "󰜫", hl = "MiniIconsBlue" },

        -- GraphQL
        [".graphqlrc"] = { glyph = "", hl = "MiniIconsPink" },
        ["graphql.config.js"] = { glyph = "", hl = "MiniIconsPink" },
        ["graphql.config.ts"] = { glyph = "", hl = "MiniIconsPink" },
      },
      filetype = {
        dotenv = { glyph = "", hl = "MiniIconsYellow" },
        javascript = { glyph = "" },
        typescript = { glyph = "" },
        yaml = { glyph = "" },
      },
    },
    init = function()
      package.preload["nvim-web-devicons"] = function()
        require("mini.icons").mock_nvim_web_devicons()
        return package.loaded["nvim-web-devicons"]
      end
    end,
  },
  {
    "nvim-tree/nvim-web-devicons",
    event = "VeryLazy",
    enabled = false,
    opts = {
      override = {
        [".prettierrc.js"] = {
          icon = "",
          color = "#f6b44a",
          cterm_color = "215",
          name = "Prettier",
        },
        [".eslintrc.js"] = {
          icon = "",
          color = "#4733bb",
          name = "ESLint",
        },
        [".eslintrc.cjs"] = {
          icon = "",
          color = "#4733bb",
          name = "ESLint",
        },
        ["eslint.config.js"] = {
          icon = "",
          color = "#4733bb",
          name = "ESLint",
        },
        ["eslint.config.mjs"] = {
          icon = "",
          color = "#4733bb",
          name = "ESLint",
        },
        ["eslint.config.cjs"] = {
          icon = "",
          color = "#4733bb",
          name = "ESLint",
        },
        ["next.config.js"] = {
          icon = "",
          color = "#7f9cf5",
          name = "Next",
        },
        ["babel.config.js"] = {
          icon = "",
          color = "#f4dd5e",
          name = "Babel",
        },
        ["yarn.lock"] = {
          icon = "",
          color = "#4a8cb7",
          name = "YarnLock",
        },
        ["Gemfile"] = {
          icon = "",
          color = "#bc4136",
          name = "Rb",
        },
        ["Gemfile.lock"] = {
          icon = "",
          color = "#bc4136",
          name = "GemfileLock",
        },
        zip = {
          icon = "",
          color = "#ebc846",
          cterm_color = "221",
          name = "Zip",
        },
        tmux = {
          icon = "",
          color = "#f8d477",
          name = "Tmux",
        },
        [".env"] = {
          icon = "",
          name = "Sh",
        },
        ["props.ts"] = {
          icon = "",
          name = "Ts",
        },
        ["test.tsx"] = {
          icon = "",
          name = "Ts",
        },
        ["test.ts"] = {
          icon = "",
          name = "Ts",
        },
        ["stories.tsx"] = {
          icon = "",
          name = "Ts",
        },
        cjs = {
          icon = "",
          name = "Cjs",
        },
      },
    },
  },
}

return M
