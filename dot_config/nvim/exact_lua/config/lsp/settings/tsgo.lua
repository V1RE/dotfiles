local inherited_root_dir = vim.lsp.config.tsgo.root_dir
local typescript = require("config.lsp.typescript")

---@type vim.lsp.Config
local tsls = {
  single_file_support = false,
  filetypes = {
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact",
  },

  root_dir = function(bufnr, on_dir)
    inherited_root_dir(bufnr, function(root)
      if typescript.is_effect_tsgo_root(root) then
        on_dir(root)
      end
    end)
  end,

  cmd = function(dispatchers, config)
    local root = assert(config and config.root_dir, "tsgo requires an Effect project root")
    return vim.lsp.rpc.start({ typescript.local_tsc(root), "--lsp", "--stdio" }, dispatchers)
  end,

  ---@type lspconfig.settings.ts_ls
  settings = {
    typescript = {

      autoClosingTags = true,
      check = { npmIsInstalled = true },
      disableAutomaticTypeAcquisition = false,
      enablePromptUseWorkspaceTsdk = true,
      implementationsCodeLens = {
        enabled = true,
        showOnAllClassMethods = true,
        showOnInterfaceMethods = true,
      },
      suggestionActions = {
        enabled = true,
      },
      preferGoToSourceDefinition = true,
      reportStyleChecksAsWarnings = false,
      tsc = {},
      suggest = {
        completeFunctionCalls = true,
        autoImports = true,
        completeJSDocs = true,
        classMemberSnippets = {
          enabled = true,
        },
        enabled = true,
        jsdoc = { generateReturns = true },
        includeAutomaticOptionalChainCompletions = true,
        includeCompletionsForImportStatements = true,
        objectLiteralMethodSnippets = { enabled = true },
        paths = true,
      },
      preferences = {
        useAliasesForRenames = true,
        preferTypeOnlyAutoImports = true,
      },
      tsserver = {
        maxTsServerMemory = 8192,
        experimental = {
          enableProjectDiagnostics = true,
        },
      },
      referencesCodeLens = {
        showOnAllFunctions = true,
        enabled = true,
      },
      workspaceSymbols = {
        excludeLibrarySymbols = true,
        scope = "allOpenProjects",
      },
      updateImportsOnFileMove = { enabled = "always" },
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
