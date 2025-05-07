local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "
vim.g.maplocalleader = " "

if vim.g.vscode then
	require("lazy").setup("user.vscode.plugins", {
		defaults = { lazy = false },
		checker = {
			enabled = false,
			concurrency = nil, ---@type number? set to 1 to check for updates very slowly
			notify = false, -- get a notification when new updates are found
			frequency = 3600, -- check for updates every hour
		},
		change_detection = {
			-- automatically check for config file changes and reload the ui
			enabled = true,
			notify = false, -- get a notification when changes are found
		},
	})
else
	require("lazy").setup("plugins", {
		checker = {
			enabled = false,
			concurrency = nil, ---@type number? set to 1 to check for updates very slowly
			notify = false, -- get a notification when new updates are found
			frequency = 3600, -- check for updates every hour
		},
		change_detection = {
			-- automatically check for config file changes and reload the ui
			enabled = true,
			notify = false, -- get a notification when changes are found
		},
		defaults = { lazy = true },
	})
end
