require("illuminate").configure({
	-- providers: provider used to get references in the buffer, ordered by priority
	providers = {
		"lsp",
		"treesitter",
		"regex",
	},
	-- delay: delay in milliseconds
	delay = 200,
	-- filetype_overrides: filetype specific overrides.
	-- The keys are strings to represent the filetype while the values are tables that
	-- supports the same keys passed to .configure except for filetypes_denylist and filetypes_allowlist
	filetype_overrides = {},
	-- filetypes_denylist: filetypes to not illuminate, this overrides filetypes_allowlist
	filetypes_denylist = {
		"dirbuf",
		"dirvish",
		"fugitive",
	},
	filetypes_allowlist = {},

	-- modes_denylist = {},
	-- modes_allowlist = {},
	providers_regex_syntax_allowlist = {},
	-- under_cursor: whether or not to illuminate under the cursor
	under_cursor = true,
	large_file_cutoff = nil,
	-- large_file_config: config to use for large files (based on large_file_cutoff).
	-- Supports the same keys passed to .configure
	-- If nil, vim-illuminate will be disabled for large files.
	large_file_overrides = nil,
	-- min_count_to_highlight: minimum number of matches required to perform highlighting
	min_count_to_highlight = 1,
	-- should_enable: a callback that overrides all other settings to
	-- enable/disable illumination. This will be called a lot so don't do
	-- anything expensive in it.
	should_enable = function(bufnr)
		return true
	end,
	-- case_insensitive_regex: sets regex case sensitivity
	case_insensitive_regex = true,
})

vim.cmd([[
let g:Illuminate_ftHighlightGroups = {
      \ 'vim:blacklist': ['vimString', 'vimLineComment',
      \         'vimFuncName', 'vimFunction', 'vimUserFunc', 'vimFunc']
      \ }
]])
