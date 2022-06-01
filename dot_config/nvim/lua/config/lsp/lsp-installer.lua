local lspinstaller = require("nvim-lsp-installer")
local lspconfig = require("lspconfig")
local schemastore = require("schemastore")

lspinstaller.setup({
	ui = {
		icons = {
			server_installed = "",
			server_pending = "",
			server_uninstalled = "",
		},
	},
})

local capabilities = require("config.lsp.handlers").capabilities
local on_attach = require("config.lsp.handlers").on_attach

for _, server in ipairs(lspinstaller.get_installed_servers()) do
	lspconfig[server.name].setup({
		settings = {
			json = {
				schemas = schemastore.json.schemas(),
			},
		},

		on_attach = on_attach,

		flags = {
			debounce_text_changes = 150,
		},

		capabilities = capabilities,
	})
end
