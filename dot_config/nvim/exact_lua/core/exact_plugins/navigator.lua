local function navigate(direction, fallback)
  return function()
    if vim.env.HC_TERMINAL_ID and vim.env.HC_TERMINAL_ID ~= "" then
      require("herdr_navigation").navigate(direction)
    else
      vim.cmd(fallback)
    end
  end
end

---@type LazyPluginSpec
return {
  "numToStr/Navigator.nvim",
  config = true,
  keys = {
    { "<c-h>", navigate("left", "NavigatorLeft"), mode = { "n", "t" } },
    { "<c-l>", navigate("right", "NavigatorRight"), mode = { "n", "t" } },
    { "<c-k>", navigate("up", "NavigatorUp"), mode = { "n", "t" } },
    { "<c-j>", navigate("down", "NavigatorDown"), mode = { "n", "t" } },
  },
}
