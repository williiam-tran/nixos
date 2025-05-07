local c = require("vscode.colors").get_colors()
require("vscode").setup({
    transparent = false,
    -- Enable italic comment
    italic_comments = true,

    -- Underline `@markup.link.*` variants
    underline_links = true,

    -- Disable nvim-tree background color
    disable_nvimtree_bg = true,

    -- Override colors (see ./lua/vscode/colors.lua)
    color_overrides = {
        vscTabCurrent = "#1E1E1E",
        vscLineNumber = "#8c8c8c",
        vscBack = "#1E1E1E",
        vscGreen = "#d1ac88",
        vscOrange = "#ffb8b0",
    },

    -- Override highlight groups (see ./lua/vscode/theme.lua)
    group_overrides = {
        -- -- this supports the same val table as vim.api.nvim_set_hl
        -- -- use colors from this colorscheme by requiring vscode.colors!
        -- Cursor = { fg = c.vscDarkBlue, bg = c.vscLightGreen, bold = true },
        Comment = { fg = c.vscPink, bg = "NONE" },
    },
})

vim.api.nvim_set_hl(0, "DiffAdd", { bg = "#20303b" })
vim.api.nvim_set_hl(0, "DiffDelete", { bg = "#37222c" })
vim.api.nvim_set_hl(0, "DiffChange", { bg = "#1f2231" })
vim.api.nvim_set_hl(0, "DiffText", { bg = "#394b70" })

vim.cmd([[
colorscheme vscode
hi Comment guifg=#dbaf84
hi String guifg=#efa29b
" hi! link Sneak Search
" hi Search guibg=#658da1
hi! illuminatedWordText cterm=underline gui=underline
let g:sneak#label = 1
hi IncSearch guibg=#658da1
hi NoiceCmdlinePopupBorderSearch guifg=#9cdcfe
hi NoiceCmdlineIconSearch guifg=#9cdcfe
hi! EasyMotionTarget guifg=#9cdcfe ctermfg=blue
hi! EasyMotionShade ctermbg=none ctermfg=none
hi! EasyMotionIncSearch guifg=#9cdcfe ctermfg=blue
highlight NvimDapVirtualText guibg=#232323 guifg=#efa29b
let g:EasyMotion_enter_jump_first = 1
let g:EasyMotion_space_jump_first = 1
let g:EasyMotion_verbose = 0
]])

vim.api.nvim_set_hl(0, "PounceGap", { fg = "NONE", bg = "NONE" })
vim.api.nvim_set_hl(0, "PounceMatch", { fg = "NONE", bg = "NONE" })
vim.api.nvim_set_hl(0, "PounceUnmatched", { fg = "#919191", bg = "NONE" })
vim.api.nvim_set_hl(0, "PounceAccept", { fg = "#9cdcfe", bg = "NONE" })
vim.api.nvim_set_hl(0, "PounceAcceptBest", { fg = "#9cdcfe", bg = "NONE" })

vim.api.nvim_set_hl(0, "FlashMatch", { fg = "NONE", bg = "NONE" })
vim.api.nvim_set_hl(0, "FlashCurrent", { fg = "NONE", bg = "NONE" })
vim.api.nvim_set_hl(0, "FlashLabel", { fg = "#9cdcfe", bg = "NONE" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#1e1e1e" })
vim.api.nvim_set_hl(0, "TelescopeNormal", { bg = "#1e1e1e" })

vim.api.nvim_set_hl(0, "DiffAdd", { bg = "#20303b" })
vim.api.nvim_set_hl(0, "DiffDelete", { bg = "#37222c" })
vim.api.nvim_set_hl(0, "DiffChange", { bg = "#1f2231" })
vim.api.nvim_set_hl(0, "DiffText", { bg = "#394b70" })


vim.api.nvim_set_hl(0, "NeogitDiffAdd", { bg = "#383e2a", blend = 20 })
vim.api.nvim_set_hl(0, "NeogitDiffDelete", { bg = "#521d1d", blend = 20 })
vim.api.nvim_set_hl(0, "NeogitDiffContext", { bg = "NONE" })
-- vim.api.nvim_set_hl(0, "NeogitHunkHeader", { bg = "NONE", fg = "#4FC1FF" })
-- vim.api.nvim_set_hl(0, "NeogitHunkHeaderHighlight", { bg = "#394b70", blend = 30, fg = "#4FC1FF" })
vim.api.nvim_set_hl(0, "NeogitDiffAddHighlight", { bg = "#383e2a", blend = 30 })
vim.api.nvim_set_hl(0, "NeogitDiffDeleteHighlight", { bg = "#521d1d", blend = 30 })
vim.api.nvim_set_hl(0, "NeogitDiffContextHighlight", { bg = "NONE" })
vim.api.nvim_set_hl(0, "NeogitCursorLine", { bg = "#2d2d2d", blend = 30 })
