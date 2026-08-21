local inherited_root_dir = vim.lsp.config.ts_ls.root_dir
local typescript = require("mason-lspconfig.lsp")

---@type vim.lsp.Config
local tsc = {
  single_file_support = false,

  root_dir = function(bufnr, on_dir)
    inherited_root_dir(bufnr, function(root)
      if typescript.is_native_typescript_root(root) then
        on_dir(root)
      end
    end)
  end,

  ---@type lspconfig.settings.ts_ls
  settings = {
    ["js/ts"] = {
      tsdk = {
        path = "./node_modules/typescript/bin",
        promptToUseWorkspaceVersion = true,
      },
      experimental = {
        useTsgo = true,
      },
      implementationsCodeLens = {
        enabled = true,
        showOnAllClassMethods = true,
        showOnInterfaceMethods = true,
      },
      reportStyleChecksAsWarnings = true,
      suggest = {
        classMemberSnippets = { enabled = true },
        objectLiteralMethodSnippets = { enabled = true },
        jsdoc = { generateReturns = true },
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
      suggestionActions = {
        enabled = true,
      },
      tsserver = {
        experimental = {
          enableProjectDiagnostics = true,
        },
      },
      validate = { enable = true },
    },
    typescript = {
      implementationsCodeLens = {
        enabled = true,
        showOnAllClassMethods = true,
        showOnInterfaceMethods = true,
      },
      reportStyleChecksAsWarnings = true,
      suggest = {
        classMemberSnippets = { enabled = true },
        objectLiteralMethodSnippets = { enabled = true },
        jsdoc = { generateReturns = true },
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
      tsdk = "./node_modules/typescript/bin",
      suggestionActions = {
        enabled = true,
      },
      tsserver = {
        experimental = {
          enableProjectDiagnostics = true,
        },
      },
      experimental = {
        useTsgo = true,
      },
      enablePromptUseWorkspaceTsdk = true,
      validate = { enable = true },
    },
  },
}

tsc.settings.javascript = vim.tbl_deep_extend("force", {}, tsc.settings.typescript, tsc.settings.javascript or {})

return tsc
