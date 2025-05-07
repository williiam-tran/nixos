require("go").setup()

local format_sync_grp = vim.api.nvim_create_augroup("goimports", {})
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*.go",
	callback = function()
		require("go.format").goimports()
	end,
	group = format_sync_grp,
})
local dap = require("dap")
local ui = require("dapui")

require("nvim-dap-virtual-text").setup({
	-- commented = true,
})

require("dapui").setup()
require("dap-go").setup({
	dap_configurations = {},
	delve = {
		path = "dlv",
		initialize_timeout_sec = 20,
		port = "${port}",
		args = {},
		build_flags = {},
		detached = vim.fn.has("win32") == 0,
		cwd = nil,
	},
	tests = {
		verbose = false,
	},
})

require("nvim-dap-virtual-text").setup({})

vim.keymap.set("n", "dp", dap.toggle_breakpoint)
-- vim.keymap.set("n", "<space>gb", dap.run_to_cursor)

-- Eval var under cursor
-- vim.keymap.set("n", "?", function()
-- 	require("dapui").eval(nil, { enter = true })
-- end)

-- Function to check if a debug process is active
local function is_debugging()
	return dap.session() ~= nil
end

-- vim.keymap.set("n", "<C-S-d>", ui.toggle())
-- vim.keymap.set("n", "<c-b>", ui.toggle())
vim.keymap.set("n", "<A-S-d>", "<Cmd>lua require('dapui').toggle()<CR>")

vim.keymap.set("n", "<F5>", "<Cmd>lua require('dap').continue()<CR>")
vim.keymap.set("n", "<leader>d", "<Cmd>lua require('dap').continue()<CR>")

-- Conditional mappings
local function set_debug_mappings()
	if is_debugging() then
		vim.keymap.set("n", "L", dap.step_into)
		vim.keymap.set("n", "J", dap.step_over)
		vim.keymap.set("n", "H", dap.step_out)
		vim.keymap.set("n", "<F5>", dap.continue)
		vim.keymap.set("n", "R", dap.restart)
	end
end

-- Set mappings when a debug session starts
dap.listeners.after.event_initialized["set_mappings"] = function()
	set_debug_mappings()
end

-- Optionally, clear mappings when the debug session ends
dap.listeners.before.event_terminated["clear_mappings"] = function()
	-- Clear the mappings if needed
	vim.keymap.del("n", "L")
	vim.keymap.del("n", "J")
	vim.keymap.del("n", "H")
	vim.keymap.del("n", "<F5>")
	vim.keymap.del("n", "R")
end

dap.listeners.before.attach.dapui_config = function()
	ui.open()
end
dap.listeners.before.launch.dapui_config = function()
	ui.open()
end

-- dap.listeners.before.event_terminated.dapui_config = function()
-- 	ui.close()
-- end
-- dap.listeners.before.event_exited.dapui_config = function()
-- 	ui.close()
-- end
