local inherited_root_dir = vim.lsp.config.tsgo.root_dir
local typescript = require("config.lsp.typescript")

---@type vim.lsp.Config
local tsls = {
  single_file_support = false,

  root_dir = function(bufnr, on_dir)
    inherited_root_dir(bufnr, function(root)
      if typescript.is_native_typescript_root(root) then
        on_dir(root)
      end
    end)
  end,

  cmd = function(dispatchers, config)
    local root = assert(config and config.root_dir, "tsgo requires a native TypeScript project root")
    return vim.lsp.rpc.start({ typescript.local_tsc(root), "--lsp", "--stdio" }, dispatchers)
  end,

  settings = {
    typescript = {
      implementationsCodeLens = {
        enabled = true,
        showOnAllClassMethods = true,
        showOnInterfaceMethods = true,
      },
      preferGoToSourceDefinition = true,
      reportStyleChecksAsWarnings = false,
      suggest = {
        classMemberSnippets = { enabled = true },
        objectLiteralMethodSnippets = { enabled = true },
      },
      preferences = {
        useAliasesForRenames = true,
        preferTypeOnlyAutoImports = true,
      },
      referencesCodeLens = {
        showOnAllFunctions = true,
        enabled = true,
      },
      format = { enable = false },
      inlayHints = {
        parameterNames = { enabled = "literals" },
        parameterTypes = { enabled = true },
        variableTypes = { enabled = true },
        propertyDeclarationTypes = { enabled = true },
        functionLikeReturnTypes = { enabled = true },
        enumMemberValues = { enabled = true },
      },
    },
  },
}

tsls.settings.javascript = vim.tbl_deep_extend("force", {}, tsls.settings.typescript, tsls.settings.javascript or {})

return tsls
