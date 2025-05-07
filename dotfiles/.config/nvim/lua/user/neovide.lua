vim.g.neovide_refresh_rate = 75
vim.g.neovide_scroll_animation_length = 0.2
vim.g.neovide_detach_on_quit = "always_detach"
vim.g.neovide_remember_window_size = true
vim.g.neovide_cursor_animate_in_insert_mode = true
vim.g.neovide_padding_top = 20
vim.g.neovide_padding_bottom = 0
vim.g.neovide_padding_right = 10
vim.g.neovide_padding_left = 10
vim.g.neovide_input_ime = true

vim.api.nvim_create_user_command("Fullscreen", function()
	-- Toggle the fullscreen setting in Lua directly
	if vim.g.neovide_fullscreen == nil then
		vim.g.neovide_fullscreen = false
	end
	vim.g.neovide_fullscreen = not vim.g.neovide_fullscreen
end, {})

vim.keymap.set("n", "fs", "<cmd>Fullscreen<CR>") -- Paste normal mode
-- vim.api.nvim_create_autocmd("QuitPre", {
-- 	callback = function()
-- 		local invalid_win = {}
-- 		local wins = vim.api.nvim_list_wins()
-- 		for _, w in ipairs(wins) do
-- 			local bufname = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(w))
-- 			if bufname == "" then
-- 				table.insert(invalid_win, w)
-- 			end
-- 		end
-- 		if #invalid_win == #wins - 1 then
-- 			-- Should quit, so we close all invalid windows.
-- 			for _, w in ipairs(invalid_win) do
-- 				vim.api.nvim_win_close(w, false)
-- 			end
-- 		end
-- 	end,
-- })

-- vim.cmd([[
-- if exists('g:neovide')
--   " Set this to 1 if you want to keep Neovide running in the background
--   let g:neovide_remember_window_size = 1
--   autocmd VimLeave * call system('taskkill /F /IM neovide.exe')
-- endif
-- ]])
