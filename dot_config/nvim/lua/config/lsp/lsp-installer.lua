local lspinstaller = require("nvim-lsp-installer")
local lspconfig = require("lspconfig")

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
	local opts = {
		on_attach = on_attach,

		flags = {
			debounce_text_changes = 150,
		},

		capabilities = capabilities,
	}

	-- if server.name == "sumneko_lua" then
	-- 	opts = vim.tbl_deep_extend("force", require("lua-dev").setup(), opts)
	-- end

	lspconfig[server.name].setup(opts)
end
