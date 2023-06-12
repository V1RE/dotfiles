---@type LazyPluginSpec[]
local M = {
  {
    "mfussenegger/nvim-jdtls",
    config = function()
      local jdtls = require("jdtls")

      local cache_vars = {}

      local root_files = {
        ".git",
        "mvnw",
        "gradlew",
        "pom.xml",
        "build.gradle",
      }

      local function get_jdtls_paths()
        if cache_vars.paths then
          return cache_vars.paths
        end

        local path = {}

        path.data_dir = vim.fn.stdpath("cache") .. "/nvim-jdtls"

        local jdtls_install = "/Users/niels/.local/share/nvim/mason/packages/jdtls"

        path.java_agent = jdtls_install .. "/lombok.jar"
        path.launcher_jar = vim.fn.glob(jdtls_install .. "/plugins/org.eclipse.equinox.launcher_*.jar")

        if vim.fn.has("mac") == 1 then
          path.platform_config = jdtls_install .. "/config_mac"
        elseif vim.fn.has("unix") == 1 then
          path.platform_config = jdtls_install .. "/config_linux"
        elseif vim.fn.has("win32") == 1 then
          path.platform_config = jdtls_install .. "/config_win"
        end

        path.bundles = {}

        ---
        -- Useful if you're starting jdtls with a Java version that's
        -- different from the one the project uses.
        ---
        path.runtimes = {}

        cache_vars.paths = path

        return path
      end

      local path = get_jdtls_paths()
      local data_dir = path.data_dir .. "/" .. vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")

      if cache_vars.capabilities == nil then
        jdtls.extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

        local ok_cmp, cmp_lsp = pcall(require, "cmp_nvim_lsp")
        cache_vars.capabilities = vim.tbl_deep_extend(
          "force",
          vim.lsp.protocol.make_client_capabilities(),
          ok_cmp and cmp_lsp.default_capabilities() or {}
        )
      end

      -- The command that starts the language server
      -- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
      local cmd = {
        -- 💀
        "java",

        "-Declipse.application=org.eclipse.jdt.ls.core.id1",
        "-Dosgi.bundles.defaultStartLevel=4",
        "-Declipse.product=org.eclipse.jdt.ls.core.product",
        "-Dlog.protocol=true",
        "-Dlog.level=ALL",
        "-javaagent:" .. path.java_agent,
        "-Xms1g",
        "--add-modules=ALL-SYSTEM",
        "--add-opens",
        "java.base/java.util=ALL-UNNAMED",
        "--add-opens",
        "java.base/java.lang=ALL-UNNAMED",

        -- 💀
        "-jar",
        path.launcher_jar,

        -- 💀
        "-configuration",
        path.platform_config,

        -- 💀
        "-data",
        data_dir,
      }

      local lsp_settings = {
        java = {
          -- jdt = {
          --   ls = {
          --     vmargs = "-XX:+UseParallelGC -XX:GCTimeRatio=4 -XX:AdaptiveSizePolicyWeight=90 -Dsun.zip.disableMemoryMapping=true -Xmx1G -Xms100m"
          --   }
          -- },
          eclipse = {
            downloadSources = true,
          },
          configuration = {
            updateBuildConfiguration = "interactive",
            runtimes = path.runtimes,
          },
          maven = {
            downloadSources = true,
          },
          implementationsCodeLens = {
            enabled = true,
          },
          referencesCodeLens = {
            enabled = true,
          },
          -- inlayHints = {
          --   parameterNames = {
          --     enabled = 'all' -- literals, all, none
          --   }
          -- },
          format = {
            enabled = true,
          },
        },
        signatureHelp = {
          enabled = true,
        },
        completion = {
          favoriteStaticMembers = {
            "org.hamcrest.MatcherAssert.assertThat",
            "org.hamcrest.Matchers.*",
            "org.hamcrest.CoreMatchers.*",
            "org.junit.jupiter.api.Assertions.*",
            "java.util.Objects.requireNonNull",
            "java.util.Objects.requireNonNullElse",
            "org.mockito.Mockito.*",
          },
        },
        contentProvider = {
          preferred = "fernflower",
        },
        extendedClientCapabilities = jdtls.extendedClientCapabilities,
        sources = {
          organizeImports = {
            starThreshold = 9999,
            staticStarThreshold = 9999,
          },
        },
        codeGeneration = {
          toString = {
            template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
          },
          useBlocks = true,
        },
      }

      -- This starts a new client & server,
      -- or attaches to an existing client & server depending on the `root_dir`.
      jdtls.start_or_attach({
        cmd = cmd,
        settings = lsp_settings,
        capabilities = cache_vars.capabilities,
        root_dir = jdtls.setup.find_root(root_files),
        flags = {
          allow_incremental_sync = true,
        },
        init_options = {
          bundles = path.bundles,
        },
      })
    end,
  },
}

return M
