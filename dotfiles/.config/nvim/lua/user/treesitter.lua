require("nvim-treesitter.install").compilers = { "clang", "gcc" }
require("nvim-treesitter.install").prefer_git = true

local status_ok, configs = pcall(require, "nvim-treesitter.configs")
if not status_ok then
	return
end

vim.defer_fn(function()
	configs.setup({
		ensure_installed = { "c", "lua", "vim", "vimdoc", "query" },

		autopairs = {
			enable = true,
		},

		highlight = {
			enable = true, -- false will disable the whole extension
			disable = { "" }, -- list of language that will be disabled
			additional_vim_regex_highlighting = true,
		},

		textobjects = {
			select = {
				enable = true,

				-- Automatically jump forward to textobj, similar to targets.vim
				lookahead = true,

				keymaps = {
					-- You can use the capture groups defined in textobjects.scm
					["af"] = "@function.outer",
					["if"] = "@function.inner",
					["ac"] = "@class.outer",
					["ic"] = "@class.inner",
				},
			},
			swap = {
				enable = true,
				swap_next = {
					["<leader>a"] = "@parameter.inner",
				},
				swap_previous = {
					["<leader>A"] = "@parameter.inner",
				},
			},
		},
	})
end, 0)
