local telescope = require("telescope")
local actions = require("telescope.actions")
-- local builtin = require("telescope.builtin")

telescope.setup({
	-- lazy load this plugin
	extensions = {
		media_files = {
			-- filetypes whitelist
			-- defaults to {"png", "jpg", "mp4", "webm", "pdf"}
			filetypes = { "png", "webp", "jpg", "jpeg" },
			find_cmd = "rg", -- find command (defaults to `fd`)
			on_enter = function(filepath)
				vim.fn.setreg("+", filepath)
				vim.notify("The image path has been copied to system clipboard!")
			end,
		},
		fzf = {
			fuzzy = true,
			override_generic_sorter = true,
			override_file_sorter = true,
			case_mod = "smart_case",
		},
	},
	defaults = {
		vimgrep_arguments = {
			"rg",
			"--color=never",
			"--no-heading",
			"--with-filename",
			"--line-number",
			"--column",
			"--smart-case",
			"--trim", -- add this value
		},

		pickers = {
			previewer = false,
			find_files = {
				previewer = false,
			},
		},

		mappings = {
			i = {
				["<Esc>"] = actions.close,
			},
			n = {
				["q"] = actions.close,
			},
		},
		layout_config = {
			horizontal = {
				preview_cutoff = 1,
				width_padding = 0.04,
				height_padding = 0.01,
				preview_width = 0.6,
				prompt_position = "top",
			},
			vertical = {
				width_padding = 0.05,
				height_padding = 1,
				preview_height = 0.5,
			},
		},
	},
})

-- builtin.find_files({
-- 	previewer = false,
-- 	shorten_path = true,
-- })

require("telescope").load_extension("fzf")
