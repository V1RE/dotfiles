---@type _.lspconfig.settings.vtsls.InlayHints
local inlayHints = {
  enumMemberValues = { enabled = true },
  variableTypes = { enabled = true },
  propertyDeclarationTypes = { enabled = true },
  functionLikeReturnTypes = { enabled = true },
  parameterTypes = { enabled = true },
  parameterNames = { enabled = "all" },
}

---@type lspconfig.options.vtsls
local tsserver = {
  single_file_support = false,
  settings = {
    vtsls = {
      experimental = {
        enableProjectDiagnostics = true,
        completion = { enableServerSideFuzzyMatch = true, entriesLimit = 25 },
      },
      enableMoveToFileCodeAction = true,
      autoUseWorkspaceTsdk = true,
      tsserver = {
        globalPlugins = {},
      },
    },
    javascript = {
      format = { enable = false },
      inlayHints,
    },
    typescript = {
      format = { enable = false },
      implementationsCodeLens = { enabled = true },
      inlayHints,
      preferences = {
        useAliasesForRenames = false,
        preferTypeOnlyAutoImports = true,
      },
      tsserver = {
        maxTsServerMemory = 8192,
      },
      referencesCodeLens = {
        showOnAllFunctions = true,
        enabled = true,
      },
      experimental = {
        aiCodeActions = {
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
  before_init = function(params, config)
    local result = vim
      .system({ "pnpm", "why", "vue", "--depth=0" }, { cwd = params.workspaceFolders[1].name, text = true })
      :wait()
    if result.stdout ~= "[]" then
      local vuePluginConfig = {
        name = "@vue/typescript-plugin",
        location = require("mason-registry").get_package("vue-language-server"):get_install_path()
          .. "/node_modules/@vue/language-server",
        languages = { "vue" },
        configNamespace = "typescript",
        enableForWorkspaceTypeScriptVersions = true,
      }
      table.insert(config.settings.vtsls.tsserver.globalPlugins, vuePluginConfig)
    end
  end,
  filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
}

return tsserver
