return {
	"tpope/vim-repeat",

	{
		"easymotion/vim-easymotion",
		dependencies = {
			"haya14busa/incsearch.vim",
			"haya14busa/incsearch-easymotion.vim",
			"haya14busa/incsearch-fuzzy.vim",
		},

		config = function()
			vim.cmd([[
			hi Comment guifg=#dbaf84
			hi String guifg=#efa29b
			hi Search guibg=#658da1
			hi IncSearch guibg=#658da1
			" hi EasyMotionTarget guifg=#9cdcfe ctermfg=none
		]])
		end,
		priority = 1200,
		event = { "VimEnter" },
		lazy = false,
	},


	"leap.nvim",

	{
		"wellle/targets.vim",
		priority = 1000,
		event = { "VimEnter" },

	},

	"tpope/vim-surround",
	"nvim-treesitter",
	"nvim-treesitter-textobjects",
	"nvim-ts-context-commentstring",
}
