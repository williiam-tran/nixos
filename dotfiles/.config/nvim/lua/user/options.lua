local options = {
	backup = false,                   -- creates a backup file
	fileformat = "dos",
	cmdheight = 4,                    -- more space in the neovim command line for displaying messages
	clipboard = "unnamedplus",        -- allows neovim to access the system clipboard
	-- completeopt = { "menuone", "noselect" }, -- mostly just for cmp
	conceallevel = 0,                 -- so that `` is visible in markdown files
	fileencoding = "utf-8",           -- the encoding written to a file
	hlsearch = false,                 -- highlight all matches on previous search pattern
	ignorecase = true,                -- ignore case in search patterns
	mouse = "a",                      -- allow the mouse to be used in neovim
	pumheight = 0,                    -- pop up menu height
	showmode = false,                 -- we don't need to see things like -- INSERT -- anymore
	-- showtabline = 1, -- always show tabs
	smartcase = true,                 -- smart case
	smartindent = true,               -- make indenting smarter again
	splitbelow = true,                -- force all horizontal splits to go below current window
	splitright = true,                -- force all vertical splits to go to the right of current window
	swapfile = false,                 -- creates a swapfile
	termguicolors = true,             -- set term gui colors (most terminals support this)
	timeoutlen = 500,                 -- time to wait for a mapped sequence to complete (in milliseconds)
	undofile = true,                  -- enable persistent undo
	updatetime = 5000,                -- faster completion (4000ms default)
	writebackup = false,              -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
	expandtab = true,                 -- convert tabs to spaces
	shiftwidth = 4,                   -- the number of spaces inserted for each indentation
	tabstop = 4,                      -- insert 2 spaces for a tab
	cursorline = false,               -- highlight the current line
	-- number = true, -- set numbered lines
	relativenumber = true,            -- set relative numbered lines
	numberwidth = 2,                  -- set number column width to 2 {default 4}
	-- signcolumn = "yes",                      -- always show the sign column, otherwise it would shift the text each time
	wrap = true,                      -- display lines as one long line
	scrolloff = 8,                    -- is one of my fav
	sidescrolloff = 8,
	guifont = "FiraCode Nerd Font Mono", -- the font used in graphical neovim applications
	laststatus = 0,
}

vim.g.netrw_ssh_cmd = "ssh -X" -- Enable X11 forwarding for better performance
vim.g.netrw_scp_cmd = "scp -q"
vim.opt.shortmess:append("aAcCFIoOstTWqixm")
vim.opt.shadafile = "NONE"
vim.o.shell = "zsh"
vim.o.shellcmdflag = "-command"
vim.o.shellquote = '"'
vim.opt.title = false
vim.opt.pumblend = 0
-- vim.o.shellredir = "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode"
-- vim.o.shellpipe = "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode"
vim.o.shellquote = ""
vim.o.shellxquote = ""

for k, v in pairs(options) do
	vim.opt[k] = v
end

vim.cmd("set whichwrap+=<,>,[,],h,l")
vim.cmd([[
set iskeyword-=-
set iskeyword-=_
set iskeyword-="
set iskeyword-='
set iskeyword-=(
set iskeyword-=)
set iskeyword-=[
set iskeyword-=]
set iskeyword-={
set iskeyword-=}
set iskeyword-=<
set iskeyword-=>
set encoding=utf-8
set modifiable
set winblend=10
highlight Comment guifg=#dbaf84
highlight String guifg=#ec8076
highlight Number guifg=#c0b6a9
set formatoptions-=cro
autocmd User TelescopePreviewerLoaded setlocal wrap
set formatoptions-=c formatoptions-=r formatoptions-=o
set nopaste
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" set guicursor=n-v-c-sm:block,i-ci-ve:ver25-Cursor,r-cr-o:hor20
" ignore case for sneak.nvim
let g:sneak#use_ic_scs = 1

" Exit if there is only nerdtree left
autocmd BufEnter * ++nested if winnr('$') == 1 && bufname() == 'NvimTree_' . tabpagenr() | quit | endif
]])

vim.cmd([[autocmd BufEnter * ++nested if winnr('$') == 1 && bufname() == 'NvimTree_' . tabpagenr() | quit | endif]])

vim.cmd([[
	let g:EasyMotion_smartcase = 1
	let g:EasyMotion_prompt = ""
	hi! EasyMotionTarget guifg=#9cdcfe ctermfg=blue
    hi! EasyMotionShade ctermbg=none ctermfg=none
    hi! EasyMotionIncSearch guifg=#9cdcfe ctermfg=blue
	silent! w
]])

vim.opt.fillchars:append("diff:╱")

-- Set EasyMotion highlights on ColorScheme
-- vim.api.nvim_create_autocmd("ColorScheme", {
-- 	pattern = "*",
-- 	callback = function()
-- 		vim.api.nvim_set_hl(0, "EasyMotionTarget", { guifg = "#9cdcfe", ctermfg = "blue" })
-- 		vim.api.nvim_set_hl(0, "EasyMotionShade", { ctermbg = "none", ctermfg = "none" })
-- 		vim.api.nvim_set_hl(0, "EasyMotionIncSearch", { guifg = "#9cdcfe", ctermfg = "blue" })
-- 	end,
-- })
