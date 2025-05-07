-- https://github.com/ThePrimeagen/harpoon/tree/harpoon2

local harpoon = require("harpoon")
harpoon:setup({})

-- basic telescope configuration
local conf = require("telescope.config").values
local function toggle_telescope(harpoon_files)
	local file_paths = {}
	for _, item in ipairs(harpoon_files.items) do
		table.insert(file_paths, item.value)
	end
	local finder = function()
		local paths = {}
		for _, item in ipairs(harpoon_files.items) do
			table.insert(paths, item.value)
		end

		return require("telescope.finders").new_table({
			results = paths,
		})
	end
	require("telescope.pickers")
		.new({}, {
			initial_mode = "normal",
			prompt_title = "Harpoon",
			finder = finder(),
			-- theme = "dropdown",
			sorting_strategy = "ascending",
			layout_config = {
				height = 0.5,
				width = 0.5,
				prompt_position = "top",
			},
			-- finder = require("telescope.finders").new_table({
			-- 	results = file_paths,
			-- }),
			previewer = false,
			sorter = conf.generic_sorter({}),
			attach_mappings = function(prompt_bufnr, map)
				map("i", "<C-d>", function()
					local state = require("telescope.actions.state")
					local selected_entry = state.get_selected_entry()
					local current_picker = state.get_current_picker(prompt_bufnr)

					table.remove(harpoon_files.items, selected_entry.index)
					current_picker:refresh(finder())
				end)
				map("n", "d", function()
					local state = require("telescope.actions.state")
					local selected_entry = state.get_selected_entry()
					local current_picker = state.get_current_picker(prompt_bufnr)

					table.remove(harpoon_files.items, selected_entry.index)
					current_picker:refresh(finder())
				end)
				return true
			end,
		})
		:find()
end

harpoon:extend({
	UI_CREATE = function(cx)
		vim.keymap.set("n", "<C-s>", function()
			harpoon.ui:select_menu_item({ vsplit = true })
		end, { buffer = cx.bufnr })
		vim.keymap.set("n", "<D-s>", function()
			harpoon.ui:select_menu_item({ vsplit = true })
		end, { buffer = cx.bufnr })
		vim.keymap.set("n", "<D-t>", function()
			harpoon.ui:select_menu_item({ tabedit = true })
		end, { buffer = cx.bufnr })

		vim.keymap.set("n", "<A-t>", function()
			harpoon.ui:select_menu_item({ tabedit = true })
		end, { buffer = cx.bufnr })
		vim.keymap.set("n", "<C-t>", function()
			harpoon.ui:select_menu_item({ tabedit = true })
		end, { buffer = cx.bufnr })
	end,
})

vim.keymap.set("n", "dy", function()
	harpoon:list():select(1)
end)
vim.keymap.set("n", "do", function()
	harpoon:list():select(2)
end)
vim.keymap.set("n", "du", function()
	harpoon:list():select(3)
end)
vim.keymap.set("n", "i4", function()
	harpoon:list():select(4)
end)

vim.keymap.set("n", "<D-e>", function()
	toggle_telescope(harpoon:list())
end, { desc = "Open harpoon window" })

vim.keymap.set("n", "<A-e>", function()
	toggle_telescope(harpoon:list())
end, { desc = "Open harpoon window" })

vim.keymap.set("n", "<C-e>", function()
	toggle_telescope(harpoon:list())
end, { desc = "Open harpoon window" })

vim.keymap.set("n", "<D-a>", function()
	harpoon:list():add()
end)

vim.keymap.set("n", "<leader>a", function()
	harpoon:list():add()
end)
