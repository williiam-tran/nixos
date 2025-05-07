local neoscroll = require("neoscroll")

local keymap = {
	["H"] = function()
		neoscroll.scroll(0.5, { move_cursor = true, duration = 100 })
	end,
	["T"] = function()
		neoscroll.scroll(-0.5, { move_cursor = true, duration = 100 })
	end,
}

local modes = { "n", "v", "x" }
for key, func in pairs(keymap) do
	vim.keymap.set(modes, key, func)
end

require("neoscroll").setup({
	hide_cursor = true,       -- Hide cursor while scrolling
	stop_eof = false,         -- Stop at <EOF> when scrolling downwards
	use_local_scrolloff = true, -- Use the local scope of scrolloff instead of the global scope
	respect_scrolloff = false, -- Stop scrolling when the cursor reaches the scrolloff margin of the file
	cursor_scrolls_alone = true, -- The cursor will keep on scrolling even if the window cannot scroll further
	easing_function = "quadratic",
	performance_mode = false, -- Disable "Performance Mode" on all buffers.
})
