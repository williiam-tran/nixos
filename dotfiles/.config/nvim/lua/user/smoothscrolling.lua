local neoscroll = require("neoscroll")

local keymap = {
	["H"] = function()
		neoscroll.scroll(0.2, { move_cursor = true, duration = 80 })
	end,
	["T"] = function()
		neoscroll.scroll(-0.2, { move_cursor = true, duration = 80 })
	end,
}

local modes = { "n", "v", "x" }
for key, func in pairs(keymap) do
	vim.keymap.set(modes, key, func)
end

require("neoscroll").setup({
	mappings = {},
	hide_cursor = false,      -- Hide cursor while scrolling
	stop_eof = false,         -- Stop at <EOF> when scrolling downwards
	use_local_scrolloff = false, -- Use the local scope of scrolloff instead of the global scope
	respect_scrolloff = false, -- Stop scrolling when the cursor reaches the scrolloff margin of the file
	cursor_scrolls_alone = true, -- The cursor will keep on scrolling even if the window cannot scroll further
	performance_mode = false, -- Disable "Performance Mode" on all buffers.
})
