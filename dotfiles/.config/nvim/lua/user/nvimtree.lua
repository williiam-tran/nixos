require("oil").setup({
	default_file_explorer = true,
	columns = {
		"icon",
		-- "permissions",
		-- "size",
		-- "mtime",
	},

	buf_options = {
		buflisted = false,
		bufhidden = "hide",
	},

	win_options = {
		number = false,
		relativenumber = false,
		signcolumn = "no",
		winblend = 20,
	},
	delete_to_trash = false,
	skip_confirm_for_simple_edits = true,
	prompt_save_on_select_new_entry = false,

	cleanup_delay_ms = 2000,

	lsp_file_methods = {
		timeout_ms = 1000,
		autosave_changes = true,
	},
	constrain_cursor = "editable",
	watch_for_changes = true,
	keymaps = {
		["<Tab>"] = { "actions.select", opts = { tab = false }, desc = "Open the entry in new tab" },
		["<CR>"] = { "actions.select", opts = { tab = false }, desc = "Open the entry in new tab" },
		["<C-s>"] = "<cmd>w<CR>",
		["<C-d>"] = "<Esc>dd",
		["<C-g>"] = { "actions.select", opts = { vertical = true }, desc = "Open the entry in a horizontal split" },
		["<c-t>"] = { "actions.select", opts = { horizontal = true }, desc = "Open the entry in a horizontal split" },
		["<D-t>"] = { "actions.select", opts = { tab = true }, desc = "Open the entry in new tab" },
		["<esc>"] = "actions.close",
		["q"] = "actions.close",
		["H"] = "actions.parent",
		["gh"] = "actions.open_cwd",
		["cd"] = "actions.cd",
		["~"] = { "actions.cd", opts = { scope = "tab" }, desc = ":tcd to the current oil directory" },
		["gx"] = "actions.open_external",
		["g."] = "actions.toggle_hidden",
	},

	use_default_keymaps = true,
	buffer_left_padding = 10,
	progress = {
		max_width = 0.9,
		min_width = { 50, 0.6 },
		max_height = { 10, 0.9 },
		min_height = { 10, 0.5 },
		border = "rounded",
		minimized_border = "none",
	},
	view_options = {
		-- Show files and directories that start with "."
		show_hidden = false,
		-- This function defines what is considered a "hidden" file
		is_hidden_file = function(name, bufnr)
			return vim.startswith(name, ".")
		end,
		-- This function defines what will never be shown, even when `show_hidden` is set
		is_always_hidden = function(name, bufnr)
			return false
		end,
		-- Sort file names in a more intuitive order for humans. Is less performant,
		-- so you may want to set to false if you work with large directories.
		natural_order = false,
		-- Sort file and directory names case insensitive
		case_insensitive = false,
		sort = {
			{ "type", "asc" },
			{ "name", "asc" },
		},
	},
	-- Extra arguments to pass to SCP when moving/copying files over SSH
	-- extra_scp_args = {},
	-- git = {
	-- 	-- Return true to automatically git add/mv/rm files
	-- 	add = function(path)
	-- 		return false
	-- 	end,
	-- 	mv = function(src_path, dest_path)
	-- 		return true
	-- 	end,
	-- 	rm = function(path)
	-- 		return true
	-- 	end,
	-- },
	float = {
		padding = 5,
		win_options = {
			winblend = 10,
		},
	},
	-- Configuration for the floating SSH window
	ssh = {
		border = "rounded",
	},
})

local constants = require("oil.constants")
local FIELD_TYPE = constants.FIELD_TYPE
local FIELD_META = constants.FIELD_META
require("oil.columns").register("simple_icon", {
	render = function(entry, conf)
		local field_type = entry[FIELD_TYPE]
		local meta = entry[FIELD_META]
		if field_type == "link" and meta then
			if meta.link_stat then
				field_type = meta.link_stat.type
			end
		end
		local icon, hl
		if field_type == "directory" then
			icon = "🚀"
			hl = "OilDirIcon"
		else
			icon = "🚀"
		end
		return { icon, hl }
	end,

	parse = function(line, conf)
		return line:match("^(%S+)%s+(.*)$")
	end,
})
