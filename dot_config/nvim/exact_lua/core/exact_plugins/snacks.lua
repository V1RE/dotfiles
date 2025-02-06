local i = require("config.icons")

---@type LazyPluginSpec[]
local M = {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      bigfile = { enabled = true },
      indent = { enabled = true },
      input = { enabled = true },
      notifier = { enabled = true },
      statuscolumn = {
        enabled = true,
        left = { "mark", "sign" }, -- priority of signs on the left (high to low)
        right = { "fold", "git" }, -- priority of signs on the right (high to low)
      },
      words = { enabled = true },
      lazygit = {},
      picker = {
        ui_select = true,
        sources = {
          files = {
            ---@param ctx snacks.picker.preview.ctx
            preview = function(ctx)
              local check_is_image = function(fileName)
                local image_extensions = { "png", "jpg", "webp" } -- Supported image formats
                local split_path = vim.split(fileName:lower(), ".", { plain = true })
                local extension = split_path[#split_path]
                return vim.tbl_contains(image_extensions, extension)
              end

              local fileName = ctx.item.file

              local bufnr = ctx.preview.win.buf
              local cwd = ctx.item.cwd

              -- Clear previous image
              if ctx.prev ~= nil then
                local prev_image = images[require("plenary.path"):new(ctx.prev.cwd):joinpath(ctx.prev.file):absolute()]

                if prev_image then
                  prev_image:clear(true)
                end
              end

              -- Fallback to the default implementation if the file is not an image or we don't have image.nvim
              if not check_is_image(fileName) or not pcall(require, "image") then
                return require("snacks").picker.preview.file(ctx)
              end

              -- Remove the content from the previous preview
              ctx.preview:set_lines({})

              local filepath = require("plenary.path"):new(cwd):joinpath(fileName):absolute()
              local autocmd

              -- Clear used memory and the images array when the picker is closed
              autocmd = vim.api.nvim_create_autocmd("WinClosed", {
                callback = function(evt)
                  if ctx.picker.closed then
                    for _, i in ipairs(images) do
                      i:clear(false)
                    end
                    images = {}

                    -- Remove the autocmd since we don't need it anymore
                    if autocmd ~= nil then
                      vim.api.nvim_del_autocmd(autocmd)
                    end
                  end
                end,
              })

              local image = images[filepath]

              if image then
                image:render()
                return
              end

              image = require("image").from_file(filepath, {
                window = ctx.win,
                buffer = bufnr,
                width = vim.api.nvim_win_get_width(ctx.win),
                with_virtual_padding = true,
              })

              images[filepath] = image

              if not image then
                return
              end
              image:render()
            end,
          },
        },
      },
    },
    keys = {
      {
        "<leader>gg",
        function()
          Snacks.lazygit.open()
        end,
        desc = "Lazygit (cwd)",
      },
      {
        "gn",
        function()
          Snacks.words.jump(1, true)
        end,
        desc = "Go to next word",
      },
      {
        "gp",
        function()
          Snacks.words.jump(-1, true)
        end,
        desc = "Go to previous word",
      },
      {
        "<leader>u",
        function()
          Snacks.picker(Snacks.picker.sources.undo)
        end,
        desc = "Undo history",
      },

      {
        "<leader><leader>",
        function()
          Snacks.picker.resume()
        end,
        desc = i.Watch .. "Resume Picker",
      },

      {
        "<leader>f",
        function()
          Snacks.picker.files({ hidden = true })
        end,
        desc = i.Telescope .. "Find files",
      },
      {
        "<leader>F",
        function()
          Snacks.picker.grep()
        end,
        desc = i.Search .. "Find text",
      },
      {
        "<leader>sh",
        function()
          Snacks.picker.help()
        end,
        desc = "Find Help",
      },

      {
        "gd",
        function()
          Snacks.picker.lsp_definitions()
        end,
        desc = i.Constant .. "Definition",
      },
      {
        "gi",
        function()
          Snacks.picker.lsp_implementations()
        end,
        desc = i.Interface .. "Implementations",
      },
      {
        "gr",
        function()
          Snacks.picker.lsp_references()
        end,
        nowait = true,
        desc = i.Reference .. "References",
      },
      {
        "<leader>lS",
        function()
          Snacks.picker.lsp_symbols({ workspace = true })
        end,
        desc = "Workspace Symbols",
      },
      {
        "<leader>ls",
        function()
          Snacks.picker.lsp_symbols({ workspace = false })
        end,
        desc = "Document Symbols",
      },
      {
        "<leader>lw",
        function()
          Snacks.picker.diagnostics()
        end,
        desc = "Workspace Diagnostics",
      },
    },
    init = function()
      vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        callback = function()
          -- Setup some globals for debugging (lazy-loaded)
          _G.dd = function(...)
            Snacks.debug.inspect(...)
          end
          _G.bt = function()
            Snacks.debug.backtrace()
          end
          vim.print = _G.dd -- Override print to use snacks for `:=` command
          --
          -- -- Create some toggle mappings
          -- Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>os")
          -- Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>ow")
          -- Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>oL")
          -- Snacks.toggle.diagnostics():map("<leader>od")
          -- Snacks.toggle.line_number():map("<leader>ol")
          -- Snacks.toggle
          --   .option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 })
          --   :map("<leader>oc")
          -- Snacks.toggle.treesitter():map("<leader>oT")
          -- Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map("<leader>ob")
          -- Snacks.toggle.inlay_hints():map("<leader>oh")
          -- Snacks.toggle.indent():map("<leader>og")
          -- Snacks.toggle.dim():map("<leader>oD")
        end,
      })
    end,
  },
}

return M
