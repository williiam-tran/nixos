require("neoscroll").setup({
	-- All these keys will be mapped to their corresponding default scrolling animation
	mappings = { "I", "K", "5<C-e>", "5<C-d>", "5<C-y>" },
	hide_cursor = true,       -- Hide cursor while scrolling
	stop_eof = true,          -- Stop at <EOF> when scrolling downwards
	use_local_scrolloff = false, -- Use the local scope of scrolloff instead of the global scope
	respect_scrolloff = true, -- Stop scrolling when the cursor reaches the scrolloff margin of the file
	cursor_scrolls_alone = true, -- The cursor will keep on scrolling even if the window cannot scroll further
	easing_function = nil,    -- Default easing function
	pre_hook = nil,           -- Function to run before the scrolling animation starts
	post_hook = nil,          -- Function to run after the scrolling animation ends
	performance_mode = false, -- Disable "Performance Mode" on all buffers.
})

local t = {}

if not vim.g.vscode then
	t["I"] = { "scroll", { "-0.15", "true", "100" } }
	t["K"] = { "scroll", { "0.15", "true", "100" } }
end

require("neoscroll.config").set_mappings(t)
