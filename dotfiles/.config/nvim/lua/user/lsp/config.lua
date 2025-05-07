local lspconfig = require("lspconfig")

local servers = { "lua_ls", "gopls" }

for _, server in pairs(servers) do
	local opts = {
		on_attach = require("user.lsp.handlers").on_attach,
		capabilities = require("user.lsp.handlers").capabilities,
	}
	lspconfig[server].setup(opts)
end
