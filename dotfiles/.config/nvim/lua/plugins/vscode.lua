return {
	{
		"hrsh7th/nvim-cmp",
		opts = function(_, opts)
			opts.sources = opts.sources or {}
			table.insert(opts.sources, {
				name = "lazydev",
				group_index = 0, -- set group index to 0 to skip loading LuaLS completions
			})
		end,
	},

	{ "chrisgrieser/nvim-spider",  lazy = false },
	{ 'echasnovski/mini.surround', version = false },
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",

		"nvim-treesitter/nvim-treesitter-textobjects",
		"JoosepAlviste/nvim-ts-context-commentstring",
		"RRethy/nvim-treesitter-textsubjects",
	},


	"chrisgrieser/nvim-various-textobjs",
	"abecodes/tabout.nvim",
	{
		"rlane/pounce.nvim",
		lazy = false,
	},
	"karb94/neoscroll.nvim",
	"tpope/vim-repeat",

	{
		"wellle/targets.vim",
		priority = 1000,
		event = { "VimEnter" },
	},

	"tpope/vim-surround",
	"nvim-treesitter",
	"nvim-treesitter-textobjects",
	"nvim-ts-context-commentstring",
	"chaoren/vim-wordmotion",
}
