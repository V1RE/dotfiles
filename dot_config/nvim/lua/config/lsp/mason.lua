local mason_ok = pcall(require, "mason")
local mason_lsp_ok = pcall(require, "mason-lspconfig")
local lsp_ok = pcall(require, "lspconfig")

if not mason_ok and mason_lsp_ok and lsp_ok then
	return
end

local mason = require("mason")
local mason_lspconfig = require("mason-lspconfig")
local lspconfig = require("lspconfig")

local settings = {
	ui = {
		border = "rounded",
		icons = {
			package_installed = "◍",
			package_pending = "◍",
			package_uninstalled = "◍",
		},
	},
	log_level = vim.log.levels.INFO,
	max_concurrent_installers = 4,
}

mason.setup(settings)
mason_lspconfig.setup()

local opts = {}

for _, server in pairs(mason_lspconfig.get_installed_servers()) do
	opts = {
		on_attach = require("config.lsp.handlers").on_attach,
		capabilities = require("config.lsp.handlers").capabilities,
	}

	server = vim.split(server, "@")[1]

	if server == "jsonls" then
		local jsonls_opts = require("config.lsp.settings.jsonls")
		opts = vim.tbl_deep_extend("force", jsonls_opts, opts)
	end

	if server == "yamlls" then
		local yamlls_opts = require("config.lsp.settings.yamlls")
		opts = vim.tbl_deep_extend("force", yamlls_opts, opts)
	end

	if server == "sumneko_lua" then
		local l_status_ok = pcall(require, "lua-dev")
		if not l_status_ok then
			return
		end

		opts = require("lua-dev").setup({ lspconfig = opts })
	end

	if server == "tsserver" then
		local tsserver_opts = require("config.lsp.settings.tsserver")
		opts = vim.tbl_deep_extend("force", tsserver_opts, opts)
	end

	lspconfig[server].setup(opts)
end
