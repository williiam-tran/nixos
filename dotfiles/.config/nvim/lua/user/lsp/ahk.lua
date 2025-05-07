local function custom_attach(client, bufnr)
	require("lsp_signature").on_attach({
		bind = true,
		use_lspsaga = false,
		floating_window = true,
		fix_pos = true,
		hint_enable = true,
		hi_parameter = "Search",
		handler_opts = { "double" },
	})
end

-- local capabilities = require("cmp_nvim_lsp").default_capabilities()

local ahk2_configs = {
	autostart = true,
	cmd = {
		"node",
		vim.fn.expand("$HOME/ahk-lsp/server/dist/server.js"),
		"--stdio",
	},
	filetypes = { "ahk", "autohotkey", "ah2" },
	init_options = {
		locale = "en-us",
		InterpreterPath = "C:/Program Files/AutoHotkey/v2.0.17/AutoHotkey64.exe",
	},
	single_file_support = true,
	flags = { debounce_text_changes = 500 },
	on_attach = custom_attach,
}

local configs = require("lspconfig.configs")
configs["ahk2"] = { default_config = ahk2_configs }

local nvim_lsp = require("lspconfig")
nvim_lsp.ahk2.setup({
	settings = {
		AutoHotkey2 = {
			interpreterPath = "C:/Program Files/AutoHotkey/v2.0.17/AutoHotkey64.exe",
		},
	},
})
