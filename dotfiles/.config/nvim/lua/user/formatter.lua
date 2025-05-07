require("conform").setup({
	event = { "LspAttach", "BufReadPost", "BufNewFile" },
	formatters_by_ft = {
		lua = { "stylua" },
		go = { "goimports" },
		-- Conform will run multiple formatters sequentially
		-- python = { "isort", "black" },
		-- Use a sub-list to run only the first available formatter
		typescriptreact = { "prettier" },
		javascriptreact = { "prettier" },
		javascript = { "prettier" },
		typescript = { "prettier" },
		json = { "prettier" },
	},

	format_on_save = {
		-- These options will be passed to conform.format()
		timeout_ms = 5000,
		lsp_fallback = true,
	},
})
