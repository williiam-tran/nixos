local function augroup(name)
	return vim.api.nvim_create_augroup("lazyvim_" .. name, { clear = true })
end

vim.api.nvim_set_hl(0, "Statusline", { link = "Normal" })
vim.api.nvim_set_hl(0, "StatuslineNC", { link = "Normal" })
-- local str = string.repeat('-', vim.api.nvim_win_get_width(0))
-- vim.opt.statusline = str

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
	group = augroup("highlight_yank"),
	callback = function()
		vim.highlight.on_yank({ higroup = "IncSearch", timeout = 150 })
	end,
})

-- resize splits if window got resized
vim.api.nvim_create_autocmd({ "VimResized" }, {
	group = augroup("resize_splits"),
	callback = function()
		local current_tab = vim.fn.tabpagenr()
		vim.cmd("tabdo wincmd =")
		vim.cmd("tabnext " .. current_tab)
	end,
})

-- close some filetypes with <q>
vim.api.nvim_create_autocmd("FileType", {
	group = augroup("close_with_q"),
	pattern = {
		"PlenaryTestPopup",
		"help",
		"lspinfo",
		"man",
		"notify",
		"qf",
		"spectre_panel",
		"startuptime",
		"tsplayground",
		"neotest-output",
		"checkhealth",
		"neotest-summary",
		"neotest-output-panel",
	},
	callback = function(event)
		vim.bo[event.buf].buflisted = false
		vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
	end,
})

vim.cmd([[
" Close the tab if NERDTree is the only window remaining in it.
autocmd BufEnter * if winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | call feedkeys(":quit\<CR>:\<BS>") | endif

" augroup illuminate_augroup
"     autocmd!
"     autocmd VimEnter * hi link illuminatedWord CursorLine
" augroup END
"
" augroup illuminate_augroup
"     autocmd!
"     autocmd VimEnter * hi illuminatedWord cterm=underline gui=underline
" augroup END
" augroup EasyMotionHighlights
" 	autocmd!
" 	autocmd ColorScheme * hi EasyMotionTarget guifg=#9cdcfe ctermfg=blue
" 	autocmd ColorScheme * hi EasyMotionShade ctermbg=none ctermfg=none
" 	autocmd ColorScheme * hi EasyMotionIncSearch guifg=#9cdcfe ctermfg=blue
" augroup END

" augroup illuminate_augroup
"     autocmd!
"     autocmd VimEnter * hi link illuminatedWord CursorLine
" augroup END

" augroup illuminate_augroup
"     autocmd!
"     autocmd VimEnter * hi illuminatedWord cterm=underline gui=underline
" augroup END
augroup QFClose
  autocmd!
  autocmd WinEnter * if winnr('$') == 1 && &buftype == "quickfix" | if getqflist({'size': 0}).size == 0 | quit | else | cclose | endif | endif
augroup END

]])

vim.cmd([[
augroup custom_highlight
	au!
	au VimEnter * highlight PounceGap cterm=none ctermfg=none ctermbg=none guifg=none guibg=none
	au VimEnter * highlight PounceUnmatched guifg=#919191 guibg=none
	au VimEnter * highlight PounceAccept ctermfg=none ctermbg=none guifg=#9cdcfe guibg=none
	au VimEnter * highlight PounceAcceptBest ctermfg=none ctermbg=none guifg=#9cdcfe guibg=none
augroup END
]])

vim.cmd([[
augroup custom_highlight_2
    autocmd!
    autocmd VimEnter,User VeryLast lua vim.defer_fn(function() SetCustomHighlights() end, 100)
	autocmd BufNewFile * startinsert
augroup END
]])

function SetCustomHighlights()
	vim.api.nvim_set_hl(0, "PounceGap", { fg = "NONE", bg = "NONE" })
	vim.api.nvim_set_hl(0, "PounceUnmatched", { fg = "#919191", bg = "NONE" })
	vim.api.nvim_set_hl(0, "PounceAccept", { fg = "#9cdcfe", bg = "NONE" })
	vim.api.nvim_set_hl(0, "FlashMatch", { fg = "NONE", bg = "NONE" })
	vim.api.nvim_set_hl(0, "FlashCurrent", { fg = "NONE", bg = "NONE" })
	vim.api.nvim_set_hl(0, "FlashLabel", { fg = "#9cdcfe", bg = "NONE" })
	vim.api.nvim_set_hl(0, "PounceAcceptBest", { fg = "#9cdcfe", bg = "NONE" })
	vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#1e1e1e" })
	vim.api.nvim_set_hl(0, "TelescopeNormal", { bg = "#1e1e1e" })
end

-- At the end of your init.lua or after all other configurations
vim.defer_fn(function()
	vim.cmd("doautocmd User VeryLast")
end, 100)

local cfg = vim.fn.stdpath("config")
Flush = function()
	local s = vim.api.nvim_buf_get_name(0)
	if string.match(s, "^" .. cfg .. "*") == nil then
		return
	end
	s = string.sub(s, 6 + string.len(cfg), -5)
	local val = string.gsub(s, "%/", ".")
	package.loaded[val] = nil
end

vim.cmd([[
autocmd BufWrite *.lua,*vim call v:lua.Flush()
]])
