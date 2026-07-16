---@diagnostic disable: missing-fields
local i = require("config.icons")

---@type LazyPluginSpec[]
return {
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-file-browser.nvim",
    },
    opts = {
      defaults = {
        prompt_prefix = i.Telescope,
        selection_caret = i.ChevronRight,
        path_display = { "truncate" },
        layout_config = {
          prompt_position = "top",
        },
        sorting_strategy = "ascending",
        dynamic_preview_title = true,

        vimgrep_arguments = {
          "rg",
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
          "--smart-case",
          "--hidden",
        },

        mappings = {
          i = {
            ["<C-j>"] = function(...)
              require("telescope.actions").cycle_history_next(...)
            end,
            ["<C-k>"] = function(...)
              require("telescope.actions").cycle_history_prev(...)
            end,
            ["<C-q>"] = function(...)
              require("telescope.actions").send_selected_to_qflist(...)
              require("telescope.actions").open_qflist(...)
            end,
            ["<M-q>"] = function(...)
              require("telescope.actions").send_to_qflist(...)
              require("telescope.actions").open_qflist(...)
            end,
          },
          n = {
            q = function(...)
              require("telescope.actions").close(...)
            end,
          },
        },
        preview = {
          ---Hook for previewing images
          ---@param filepath string
          ---@param bufnr number
          ---@param opts { winid: number }
          mime_hook = function(filepath, bufnr, opts)
            ---Check if the file is an image
            ---@param file string
            ---@return boolean
            local is_image = function(file)
              local image_extensions = { "png", "jpg" } -- Supported image formats
              local split_path = vim.split(file:lower(), ".", { plain = true })
              local extension = split_path[#split_path]
              return vim.tbl_contains(image_extensions, extension)
            end
            if is_image(filepath) then
              local height = vim.api.nvim_win_get_height(opts.winid)
              local width = vim.api.nvim_win_get_width(opts.winid)
              local term = vim.api.nvim_open_term(bufnr, {})
              local function send_output(_, data, _)
                for _, d in ipairs(data) do
                  vim.api.nvim_chan_send(term, d .. "\r\n")
                end
              end
              vim.fn.jobstart({
                "chafa",
                "--center=on",
                "--clear",
                "--format=symbols",
                "--view-size=" .. width .. "x" .. height,
                "--scale=max",
                filepath,
              }, { on_stdout = send_output, stdout_buffered = true, pty = true })
            else
              require("telescope.previewers.utils").set_preview_message(bufnr, opts.winid, "Binary cannot be previewed")
            end
          end,
        },
      },
      pickers = {
        find_files = {
          find_command = { "fd", "--type=file", "--hidden", "--exclude=.git", "--strip-cwd-prefix" },
          hidden = true,
        },
      },
      extensions = {
        file_browser = {
          theme = "dropdown",
          hijack_netrw = false,
          path = "%:p:h",

          mappings = {
            i = {
              ["<ESC>"] = false,
            },
          },
        },
      },
    },
    keys = {
      {
        "<leader>K",
        function()
          require("telescope").extensions.file_browser.file_browser()
        end,
        desc = i.Class .. "File manager",
      },
    },
  },
}
