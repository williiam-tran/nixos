require("mason").setup()
require("mason-lspconfig").setup({
	ensure_installed = { "lua_ls" },
})

require("neodev").setup({
	library = {
		enabled = true, -- when not enabled, neodev will not change any settings to the LSP server
		-- these settings will be used for your Neovim config directory
		runtime = true, -- runtime path
		types = true, -- full signature, docs and completion of vim.api, vim.treesitter, vim.lsp and others
		-- plugins = true, -- installed opt or start plugins in packpath
		-- you can also specify the list of plugins to make available as a workspace library
		plugins = { "nvim-treesitter", "plenary.nvim", "telescope.nvim" },
	},
})

require("lspconfig").lua_ls.setup({
	on_init = function(client)
		-- local path = client.workspace_folders[1].name
		-- if not vim.loop.fs_stat(path .. "/.luarc.json") and not vim.loop.fs_stat(path .. "/.luarc.jsonc") then
		client.config.settings = vim.tbl_deep_extend("force", client.config.settings, {
			Lua = {
				diagnostics = {
					globals = { "vim" },
					disable = {
						"missing-fields"
					}
				},

				runtime = {
					version = "LuaJIT",
				},
				-- Make the server aware of Neovim runtime files
				workspace = {
					checkThirdParty = false,
					library = {
						vim.env.VIMRUNTIME,
					},
				},
			},
		})

		-- client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
		-- end
		return true
	end,
})

-- vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
-- vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
-- vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
-- vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)
--
-- vim.api.nvim_create_autocmd("LspAttach", {
-- 	group = vim.api.nvim_create_augroup("UserLspConfig", {}),
-- 	callback = function(ev)
-- 		--     -- Buffer local mappings.
-- 		--     -- See `:help vim.lsp.*` for documentation on any of the below functions
-- 		local opts = { buffer = ev.buf }
-- 		vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
-- 		vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
-- 		vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
-- 		vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
-- 		--     vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
-- 		--     vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
-- 		--     vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
-- 		--     vim.keymap.set('n', '<space>wl', function()
-- 		--       print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
-- 		--     end, opts)
-- 		--     vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
-- 		--     vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
-- 		vim.keymap.set({ "n", "v" }, "ca", vim.lsp.buf.code_action, opts)
-- 		--     vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
-- 		--     vim.keymap.set('n', '<space>f', function()
-- 		-- vim.lsp.buf.format { async = true }
-- 		-- end, opts)
-- 	end,
-- })
