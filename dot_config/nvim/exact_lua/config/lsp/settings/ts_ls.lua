local util = require("lspconfig.util")

---@type lspconfig.options.ts_ls
local ts_ls = {
  root_dir = function(filename)
    return vim.fs.dirname(vim.fs.find(".git", { path = filename, upward = true })[1])
      or util.root_pattern("package.json", "tsconfig.json", "jsconfig.json")(filename)
  end,
  single_file_support = false,
  cmd = { "tsgo", "--lsp", "--stdio" },
  settings = {
    complete_function_calls = true,
    javascript = {
      format = { enable = false },
    },
    typescript = {
      tsserver = {
        nodePath = "~/.local/share/mise/installs/node/latest/bin/node --max-old-space-size=8192",
        maxTsServerMemory = 8192,
      },
      updateImportsOnFileMove = { enabled = "always" },
      suggest = {
        completeFunctionCalls = true,
      },
      format = { enable = false },
      preferences = {
        useAliasesForRenames = true,
        preferTypeOnlyAutoImports = true,
      },
      referencesCodeLens = {
        showOnAllFunctions = true,
        enabled = true,
      },
      inlayHints = {
        enumMemberValues = { enabled = true },
        functionLikeReturnTypes = { enabled = true },
        parameterNames = { enabled = "literals" },
        parameterTypes = { enabled = true },
        propertyDeclarationTypes = { enabled = true },
        variableTypes = { enabled = false },
      },
    },
  },
}

ts_ls.settings.javascript = vim.tbl_deep_extend("force", {}, ts_ls.settings.typescript, ts_ls.settings.javascript or {})

return ts_ls
