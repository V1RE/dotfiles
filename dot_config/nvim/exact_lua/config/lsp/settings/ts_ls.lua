local util = require("lspconfig.util")

---@type lspconfig.options.ts_ls
local ts_ls = {
  root_dir = function(filename)
    return util.find_git_ancestor(filename)
      or util.root_pattern("package.json", "tsconfig.json", "jsconfig.json")(filename)
  end,
  single_file_support = false,
  settings = {
    javascript = {
      format = { enable = false },
    },
    typescript = {
      tsserver = {
        nodePath = "~/.local/share/mise/installs/node/latest/bin/node --max-old-space-size=8192",
        maxTsServerMemory = 8192,
        experimental = {
          expandableHover = true,
          enableProjectDiagnostics = true,
        },
      },
      format = { enable = false },
      preferGoToSourceDefinition = false,
      suggest = {
        completeFunctionCalls = true,
      },
      preferences = {
        useAliasesForRenames = false,
        importModuleSpecifier = "non-relative",
        preferTypeOnlyAutoImports = true,
      },
      experimental = {
        aiCodeActions = {
          extractInterface = true,
          missingFunctionDeclaration = true,
          extractType = true,
          inferAndAddTypes = true,
          extractFunction = true,
          extractConstant = true,
          classIncorrectlyImplementsInterface = true,
          classDoesntImplementInheritedAbstractMember = true,
          addNameToNamelessParameter = true,
        },
        enableProjectDiagnostics = true,
      },
    },
  },
}

return ts_ls
