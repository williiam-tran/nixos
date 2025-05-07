local status_ok = pcall(require, "lspconfig")
if not status_ok then
	return
end

require("user.lsp.config")
require("user.lsp.handlers").setup()
require("user.lsp.lsp-format")
require("user.lsp.null-ls")
