vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.cmd([[
hi Comment guifg=#dbaf84
hi String guifg=#efa29b
hi! link Sneak Search
hi Search guibg=#658da1
hi! illuminatedWordText cterm=underline gui=underline			
let g:sneak#label = 1
hi IncSearch guibg=#658da1
highlight NvimDapVirtualText guibg=#232323 guifg=#efa29b
let g:EasyMotion_enter_jump_first = 1
let g:EasyMotion_space_jump_first = 1
let g:EasyMotion_verbose = 0
set cmdheight=50
]])

vim.api.nvim_set_hl(0, "PounceUnmatched", { link = "None" })
vim.api.nvim_set_hl(0, "PounceMatch", { fg = "NONE", bg = "#47596d" })
vim.api.nvim_set_hl(0, "PounceGap", { fg = "NONE", bg = "NONE" })
vim.api.nvim_set_hl(0, "PounceAccept", { fg = "#ebffc5", bg = "#1e1e1e" })
vim.api.nvim_set_hl(0, "PounceAcceptBest", { fg = "#ebffc5", bg = "#1e1e1e" })
vim.o.cmdheight = 50

require('ts_context_commentstring').setup {
    enable_autocmd = false,
}

require("pounce").setup({
    accept_keys = "IJKLSFUOAD",
    accept_best_key = "<Space>",
    multi_window = true,
    debug = false,
})
