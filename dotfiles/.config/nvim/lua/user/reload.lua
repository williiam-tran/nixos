local M = {}

local reload = require("plenary.reload")

function M.reload_config()
	--print("Starting configuration reload...")

	-- Reload init.lua
	local init_path = vim.fn.stdpath("config") .. "init.lua"
	if vim.fn.filereadable(init_path) == 1 then
		dofile(init_path)
		vim.cmd("source " .. init_path)
		-- print("init.lua reloaded")
	else
		--print("init.lua not found or not readable")
	end

	-- Get all Lua files in the user directory and its subdirectories
	local user_dir = vim.fn.stdpath("config") .. "/lua/user"
	local lua_files = vim.fn.glob(user_dir .. "/*.lua", false, true)
	vim.list_extend(lua_files, vim.fn.glob(user_dir .. "/**/*.lua", false, true))

	-- print("Scanning directory: " .. user_dir)
	-- print("Found " .. #lua_files .. " Lua files")

	-- List of modules to ignore
	local ignore_modules = {
		"user.lsp",
		"plugins",
		"user.autocmds",
		"user.lazy",
		"user.codecompanion",
		"user.mason",
		"user.legendary",
		"user.noice",
		"user.project",
		"user.youcompleteme",
		"user.colorizer",
		"user.copilot",
		"user.debugger",
		"user.filetype",
		"user.formatter",
		"user.fzf",
		"user.git",
		"user.go",
		"user.illuminate",
		"user.indentline",
		"user.options",
		"user.tabout",
		"user.toggleterm",
		"user.reload", -- Add this to ignore the reload module itself
	}

	local modules = { "user.keymaps" }
	for _, file in ipairs(lua_files) do
		local relative_path = file:sub(#user_dir + 2, -5) -- Remove user_dir and .lua extension
		-- Skip files in the lsp folder
		if not relative_path:match("^lsp\\") then
			local module_name = relative_path:gsub("\\", ".")
			if module_name == "" then
				module_name = vim.fn.fnamemodify(file, ":t:r")
			end
			local full_module_name = "user." .. module_name

			-- Check if the module should be ignored
			if not vim.tbl_contains(ignore_modules, full_module_name) then
				table.insert(modules, full_module_name)
				-- print("Found module: " .. full_module_name)
			else
				--print("Ignoring module: " .. full_module_name)
			end
		else
			--print("Skipping LSP module: " .. relative_path)
		end
	end

	-- Reload each module
	for _, module in ipairs(modules) do
		pcall(function()
			--print("Reloading module: " .. module)
			reload.reload_module(module, false)
			require(module)
		end)
	end

	--print("Configuration reload completed!")
end

return M
