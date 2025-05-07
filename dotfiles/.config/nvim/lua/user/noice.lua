require("noice").setup({
	routes = {
		{
			filter = {
				event = "msg_show",
				kind = "",
				find = "written",
			},
			opts = { skip = true },
		},
	},
	lsp = {
		-- override markdown rendering so that **cmp** and other plugins use **Treesitter**
		signature = {
			enabled = false,
		},
		override = {
			["vim.lsp.util.convert_input_to_markdown_lines"] = true,
			["vim.lsp.util.stylize_markdown"] = true,
			["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
		},
	},
	cmdline = {
		enabled = true,   -- enables the Noice cmdline UI
		view = "cmdline_popup", -- view for rendering the cmdline. Change to `cmdline` to get a classic cmdline at the bottom
		format = {
			cmdline = { pattern = "^:", icon = "", lang = "vim" },
			search_down = { kind = "search", pattern = "^/", icon = " ", lang = "regex" },
			search_up = { kind = "search", pattern = "^%?", icon = " ", lang = "regex" },
			filter = { pattern = "^:%s*!", icon = "$", lang = "bash" },
			lua = { pattern = { "^:%s*lua%s+", "^:%s*lua%s*=%s*", "^:%s*=%s*" }, icon = "", lang = "lua" },
			help = { pattern = "^:%s*he?l?p?%s+", icon = "" },
			-- 	-- lua = false, -- to disable a format, set to `false`
			input = { view = "cmdline_input", icon = "󰥻 " }, -- Used by input()
		},
	},
	messages = {
		enabled = true, -- enables the Noice messages UI
	},
	presets = {
		bottom_search = false,  -- use a classic bottom cmdline for search
		command_palette = false, -- position the cmdline and popupmenu together
		long_message_to_split = true, -- long messages will be sent to a split
		inc_rename = false,     -- enables an input dialog for inc-rename.nvim
		lsp_doc_border = false, -- add a border to hover docs and signature help
	},
})

require("dressing").setup({
	input = {
		-- Set to false to disable the vim.ui.input implementation
		enabled = false,

		default_prompt = "Input",

		trim_prompt = true,

		title_pos = "left",

		insert_only = true,
		start_in_insert = true,

		-- These are passed to nvim_open_win
		border = "rounded",

		relative = "editor",

		prefer_width = 40,
		width = nil,
		-- min_width and max_width can be a list of mixed types.
		-- min_width = {20, 0.2} means "the greater of 20 columns or 20% of total"
		max_width = { 140, 0.9 },
		min_width = { 20, 0.2 },

		buf_options = {},

		mappings = {
			n = {
				["q"] = "Close",
				["<CR>"] = "Confirm",
			},
			i = {
				["<C-c>"] = "Close",
				["<CR>"] = "Confirm",
				["<c-k>"] = "HistoryPrev",
				["<c-j>"] = "HistoryNext",
			},
		},

		override = function(conf)
			-- This is the config that will be passed to nvim_open_win.
			-- Change values here to customize the layout
			return conf
		end,

		-- see :help dressing_get_config
		get_config = nil,
	},
	select = {
		-- Set to false to disable the vim.ui.select implementation

		enabled = true,
		-- Priority list of preferred vim.select implementations
		backend = { "telescope", "fzf_lua", "fzf", "builtin", "nui" },

		-- Trim trailing `:` from prompt
		trim_prompt = true,

		-- Options for telescope selector
		-- These are passed into the telescope picker directly. Can be used like:
		-- telescope = require('telescope.themes').get_ivy({...})
		telescope = nil,

		-- Options for fzf selector
		fzf = {
			window = {
				width = 0.5,
				height = 0.4,
			},
		},

		-- Options for fzf-lua
		fzf_lua = {
			-- winopts = {
			--   height = 0.5,
			--   width = 0.5,
			-- },
		},

		-- Options for nui Menu
		nui = {
			position = "50%",
			size = nil,
			relative = "editor",
			border = {
				style = "rounded",
			},
			buf_options = {
				swapfile = false,
				filetype = "DressingSelect",
			},
			win_options = {
				winblend = 0,
			},
			max_width = 80,
			max_height = 40,
			min_width = 40,
			min_height = 10,
		},

		-- Options for built-in selector
		builtin = {
			-- Display numbers for options and set up keymaps
			show_numbers = true,
			-- These are passed to nvim_open_win
			border = "rounded",
			-- 'editor' and 'win' will default to being centered
			relative = "editor",

			buf_options = {},
			win_options = {
				cursorline = false,
				cursorlineopt = "both",
			},

			-- These can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
			-- the min_ and max_ options can be a list of mixed types.
			-- max_width = {140, 0.8} means "the lesser of 140 columns or 80% of total"
			width = nil,
			max_width = { 140, 0.8 },
			min_width = { 40, 0.2 },
			height = nil,
			max_height = 0.9,
			min_height = { 10, 0.2 },

			-- Set to `false` to disable

			mappings = {
				n = {
					["q"] = "Close",
					["<CR>"] = "Confirm",
					["k"] = "HistoryPrev",
					["j"] = "HistoryNext",
				},
				i = {
					["<C-c>"] = "Close",
					["<CR>"] = "Confirm",
					["<c-k>"] = "HistoryPrev",
					["<c-j>"] = "HistoryNext",
				},
				-- ["<Esc>"] = "Close",
				-- ["<C-c>"] = "Close",
				-- ["<CR>"] = "Confirm",
			},

			override = function(conf)
				-- This is the config that will be passed to nvim_open_win.
				-- Change values here to customize the layout
				return conf
			end,
		},

		-- Used to override format_item. See :help dressing-format
		format_item_override = {},
	},
})

vim.ui.select = require("dressing").select

-- Enhance command-line completion
vim.cmd([[
  function! FzfCompleteCommands(arglead, cmdline, cursorpos)
    let l:cmds = getcompletion(a:arglead, 'command')
    return join(l:cmds, "\n")
  endfunction

  cnoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<C-z>\<CR>"
  set wildcharm=<C-z>
  cmap <expr> <Tab> "\<C-r>=FzfCompleteCommands('" . escape(getcmdline(), "'") . "', getcmdline(), getcmdpos())\<CR>\<C-z>"
]])
