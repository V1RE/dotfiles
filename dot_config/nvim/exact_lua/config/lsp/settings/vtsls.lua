local inherited_root_dir = vim.lsp.config.vtsls.root_dir
local typescript = require("config.lsp.typescript")

---@type vim.lsp.Config
local vtsls = {
  single_file_support = false,

  root_dir = function(bufnr, on_dir)
    inherited_root_dir(bufnr, function(root)
      if not typescript.is_native_typescript_root(root) then
        on_dir(root)
      end
    end)
  end,

  ---@type lspconfig.settings.vtsls
  settings = {
    vtsls = {
      enableMoveToFileCodeAction = true,
      autoUseWorkspaceTsdk = true,
      experimental = {
        maxInlayHintLength = 30,
        completion = {
          enableServerSideFuzzyMatch = true,
        },
      },
    },
    typescript = {
      updateImportsOnFileMove = { enabled = "always" },
      implementationsCodeLens = { enabled = true, showOnAllClassMethods = true, showOnInterfaceMethods = true },
      suggest = {
        completeFunctionCalls = true,
      },
      format = { enable = false },
      preferences = {
        useAliasesForRenames = true,
        preferTypeOnlyAutoImports = true,
      },
      tsserver = {
        maxTsServerMemory = 8192,
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

vtsls.settings.javascript = vim.tbl_deep_extend("force", {}, vtsls.settings.typescript, vtsls.settings.javascript or {})

return vtsls
