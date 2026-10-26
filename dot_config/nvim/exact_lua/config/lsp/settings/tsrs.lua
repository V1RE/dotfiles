-- https://github.com/oxc-project/tsrs/blob/main/docs/LSP.md
---@type vim.lsp.Config
local tsrs = {
  -- Prefer the project's pinned tsrs, fall back to the global one from mise.
  cmd = function(dispatchers, config)
    local local_bin = vim.fs.joinpath((config or {}).root_dir or "", "node_modules", ".bin", "tsrs")
    local bin = vim.fn.executable(local_bin) == 1 and local_bin or "tsrs"
    return vim.lsp.rpc.start({ bin, "--lsp", "--stdio" }, dispatchers)
  end,
  filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
  -- Same project-root and Deno detection as vtsls.
  root_dir = vim.lsp.config.vtsls.root_dir,

  settings = {
    ["js/ts"] = {
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
  },
}

tsrs.settings.javascript = vim.tbl_deep_extend("force", {}, tsrs.settings.typescript, tsrs.settings.javascript or {})

return tsrs
