local opts = { noremap = true, silent = true }
local keymap = vim.api.nvim_set_keymap

local textObj = require("various-textobjs")
local function is_windows()
    ---@diagnostic disable-next-line: undefined-field
    return vim.loop.os_uname().sysname == "Windows_NT"
end
-- Universal

if not is_windows() then
    vim.keymap.set("v", "y", function()
        vim.cmd('normal! "+y')
        vim.defer_fn(function()
            vim.fn.system("xclip -selection clipboard", vim.fn.getreg("+"))
        end, 50)
    end, { silent = true })
end
-- Map Tab to go to the next search match
vim.api.nvim_set_keymap('n', '<Tab>', 'n', { noremap = true, silent = true })
-- Map Shift+Tab to go to the previous search match
vim.api.nvim_set_keymap('n', '<S-Tab>', 'N', { noremap = true, silent = true })


keymap("n", "I", "C", opts)
keymap("v", "I", "C", opts)
keymap("x", "I", "C", opts)
keymap("n", "m", "<C-w>", opts)

keymap("v", "z", "<esc>", opts)
keymap("o", "z", "<esc>", opts)
keymap("v", "b", "<esc>", opts)
keymap("o", "b", "<esc>", opts)
keymap("o", "i", "i", opts)
keymap("n", "K", "^", opts)
keymap("n", "N", "W", opts)
keymap("x", "N", "$", opts)
keymap("v", "N", "$", opts)
keymap("n", "w", "o", opts)
keymap("v", "w", "e", opts)
keymap("n", "e", "d", opts)
keymap("n", "a", "i", opts)
keymap("v", "e", "d", opts)
keymap("x", "e", "d", opts)

keymap("v", "t", "k", opts)
keymap("v", "h", "j", opts)
keymap("n", "t", "k", opts)
keymap("n", "h", "j", opts)

keymap("n", "T", "<C-u>", opts)
keymap("n", "H", "<C-d>", opts)

keymap("n", "eq", 'ciq<C-r>"', opts)
keymap("i", "kh", "<Esc><cmd>w<CR>", opts)
keymap("i", "jg", "<Esc><cmd>w<CR>", opts)
keymap("i", "mg", "<Esc><cmd>w<CR>", opts)
keymap("i", "<C-S>", "<Esc><cmd>w<CR>", opts)
keymap("i", "<C-BS>", "<C-w>", opts)
keymap("n", ":", "V", opts)
keymap("n", "=", "V", opts)
keymap("n", ">", "V", opts)

keymap("n", "<C-S-d>", "<Nop>", opts)
keymap("n", "<Space>", "<Nop>", opts)
keymap("n", "<c-n>", "<Nop>", opts)
-- keymap("i", "<C-h>", "<C-w>", opts)
keymap("i", "<C-e>", "<C-o>de", opts)

if not vim.g.vscode then
    keymap("n", "s", "<cmd>Pounce<CR>", opts)
    keymap("v", "s", '"zy<cmd>PounceReg z<cr>', opts)
else
    keymap("n", "s", "<cmd>Pounce<CR>", opts)
    -- keymap("n", "t", "<cmd>Pounce<CR>", opts)
    -- keymap("v", "t", '"zy<cmd>PounceReg z<cr>', opts)
end

-- keymap("o", "o", "w", opts)
keymap("n", "l", "u", opts)
-- keymap("n", "w", "o", opts)
keymap("n", "n", "w", opts)
keymap("v", "n", "w", opts)
keymap("x", "n", "w", opts)
keymap("n", "k", "b", opts)
keymap("v", "k", "b", opts)
keymap("x", "k", "b", opts)
keymap("n", "-", "x", opts)
keymap("v", "-", "d", opts)
keymap("x", "-", "d", opts)
keymap("n", "i", "c", opts)

keymap("n", "<c-s>", "<Esc><C-W>l", opts)
keymap("n", "<c-k>", "<Esc><C-W>h", opts)
keymap("n", "<c-t>", "<Esc><C-W>k", opts)
keymap("n", "<c-h>", "<Esc><C-W>j", opts)

function ToAnyNumber()
    -- after this function called, already in insert mode and deleted everything inside the quote.
    require("various-textobjs").number("inner")
end

keymap("o", "n", "<cmd>lua ToAnyNumber()<CR>", opts) --, 6

function AroundAnyBracket()
    -- after this function called, already in insert mode and deleted everything inside the quote.
    require("various-textobjs").anyBracket("outer")
end

function AppendToAnyBracket()
    -- after this function called, already in insert mode and deleted everything inside the quote.
    require("various-textobjs").anyBracket("inner")
    local keys = vim.api.nvim_replace_termcodes('<c-r>"', true, false, true)
    vim.api.nvim_feedkeys(keys, "i", false)
end

function AroundAnyQuote()
    -- after this function called, already in insert mode and deleted everything inside the quote.
    require("various-textobjs").anyQuote("outer")
    -- local keys = vim.api.nvim_replace_termcodes('<c-r>"', true, false, true)
    -- vim.api.nvim_feedkeys(keys, "i", false)
end

function AppendToAnyQuote()
    -- after this function called, already in insert mode and deleted everything inside the quote.
    require("various-textobjs").anyQuote("inner")
    local keys = vim.api.nvim_replace_termcodes('<c-r>"', true, false, true)
    vim.api.nvim_feedkeys(keys, "i", false)
end

vim.api.nvim_set_keymap(
    "o",
    "q",
    [[:lua require("various-textobjs").toNextQuotationMark()<CR>]],
    { noremap = true, silent = true }
)
vim.api.nvim_set_keymap("o", "ep", [[:lua AppendToAnyQuote()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap("o", "ap", [[:lua AroundAnyQuote()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "ap", [[:lua AroundAnyQuote()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap("x", "ap", [[:lua AroundAnyQuote()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap("o", "aw", [[:lua AroundAnyBracket()<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap("o", "ew", [[:lua AppendToAnyBracket()<CR>]], { noremap = true, silent = true })

vim.cmd([[
map <c-up> <C-w><up>
map <c-down> <C-w><down>
map <c-left> <C-w><left>
map <c-right> <C-w><right>
nnoremap , :
cnoremap <C-v> <c-r>+
]])

-- vim.keymap.set("v", "<C-r>", '"hy:%s/\\v<C-r>h//g<left><left>', { desc = "change selection" })
vim.keymap.set("v", "<C-r>", '"hy:%s/<C-r>=escape(@h, "/\\[].*$^~")<CR>//g<left><left>', { desc = "change selection" })

keymap("n", "<C-S-e>", "<cmd>lua MiniFiles.open()<CR>", opts)
keymap("n", "<D-S-e>", "<cmd>lua require('oil').toggle_float()<CR>", opts)
-- keymap("n", "<A-S-e>", "<cmd>NvimTreeToggleFindFile<CR>", opts)
keymap("n", "<A-b>", "<cmd>NvimTreeFindFileToggle<CR>", opts)
keymap("n", "<C-b>", "<cmd>NvimTreeFindFileToggle<CR>", opts)
keymap("t", "<Esc>", "<C-\\><C-n>", opts)

-- keymap("n", "<A-k>", ":m .-2<CR>==", opts) -- move line down(n)
keymap("v", "<c-t>", ":m '<-2<CR>gv=gv", opts) -- move line up(v)
keymap("v", "<c-h>", ":m '>+1<CR>gv=gv", opts) -- move line up(v)

-- keymap("n", "<A-j>", ":m .+1<CR>==", opts) -- move line up(n)

vim.cmd([[
nnoremap <leader>q :bp<cr>:bd #<cr>
]])

-- Git
keymap("n", "gs", "<cmd>Neogit<CR>", opts)
keymap("n", "gp", "<cmd>Neogit pull<CR>", opts)
keymap("n", "y", '"+y', opts)
keymap("n", "p", '"+p', opts)
keymap("n", "<C-Z>", "<Esc>u", opts)
keymap("n", "0", "^", opts)
keymap("n", "ge", "g_", opts)

keymap("v", "ge", "g_", opts)
keymap("v", "0", "^", opts)
keymap("n", "e", "d", opts)
keymap("o", "e", "d", opts)

keymap("n", "o", "w", opts)
keymap("o", "o", "w", opts)

-- Next/Previous cursor position
keymap("n", "<A-U>", "<C-O>", opts)
keymap("n", "<A-O>", "<C-I>", opts)


keymap("n", "<M-U>", "<C-O>", opts)
keymap("n", "<M-O>", "<C-I>", opts)
keymap("n", "<C-l>", "<C-O>", opts)
keymap("n", "<C-w>", "<C-I>", opts)

keymap("n", "<D-l>", "<C-i>", opts)
keymap("n", "<D-w>", "<C-o>", opts)


-- Ctrl+Backspace to delete word
keymap("i", "<C-BS>", "<C-W>", opts)
-- keymap("n", "@", "*", opts)

local function get_visual_selection()
    local s_start = vim.fn.getpos("'<")
    local s_end = vim.fn.getpos("'>")
    local n_lines = math.abs(s_end[2] - s_start[2]) + 1
    local lines = vim.api.nvim_buf_get_lines(0, s_start[2] - 1, s_end[2], false)
    lines[1] = string.sub(lines[1], s_start[3], -1)
    if n_lines == 1 then
        lines[n_lines] = string.sub(lines[n_lines], 1, s_end[3] - s_start[3] + 1)
    else
        lines[n_lines] = string.sub(lines[n_lines], 1, s_end[3])
    end
    return table.concat(lines, "\n")
end

function ReplaceInQuickfixVisual()
    vim.cmd("normal! gv") -- Reselect the last visual selection
    ReplaceInQuickfix()
end

function ReplaceInQuickfix()
    -- Check if the quickfix list is empty
    if vim.fn.getqflist({ size = 0 }).size == 0 then
        print("Quickfix list is empty")
        return
    end

    local old_text

    -- Check if there's a visual selection
    if vim.fn.mode() == "n" then
        -- Normal mode: get word under cursor
        old_text = vim.fn.expand("<cword>")
    else
        -- Visual mode: get selected text
        old_text = get_visual_selection()
    end

    old_text = old_text:gsub("\n", " "):gsub("%s+", " "):gsub("^%s*(.-)%s*$", "%1") -- Replace newlines with spaces, collapse multiple spaces, and trim

    local new_text = vim.fn.input("Replace " .. old_text .. " with: ", old_text)

    if new_text ~= "" and new_text ~= old_text then
        -- Use pcall to catch any errors during execution
        local success, error_msg = pcall(function()
            -- Escape special characters for Vim's regex
            local escaped_old_text = old_text:gsub("([%^%$%(%)%%%.%[%]%*%+%-%?])", "\\%1")
            -- Use word boundaries only if it's a single word
            local pattern = old_text:find("%s") and escaped_old_text or "\\<" .. escaped_old_text .. "\\>"
            vim.cmd(string.format("cdo %%s/%s/%s/gc | update", pattern, vim.fn.escape(new_text, "/\\")))
        end)

        if not success then
            print("Error occurred: " .. error_msg)
        else
            print("Replacement complete. Files have been updated")
        end
    end
end

keymap("n", ";", "<cmd>Telescope commands<CR>", opts)

-- vim.api.nvim_set_keymap("n", "<C-r>", [[:lua ReplaceInQuickfix()<CR>]], { noremap = true, silent = true })
-- vim.api.nvim_set_keymap("v", "<C-r>", [[:lua ReplaceInQuickfixVisual()<CR>]], { noremap = true, silent = true })

local function setup_quickfix_keymaps()
    vim.api.nvim_set_keymap("n", "<C-r>", [[:lua ReplaceInQuickfix()<CR>]], { noremap = true, silent = true })
    vim.api.nvim_buf_set_keymap(
        0,
        "v",
        "<C-r>",
        [[:lua ReplaceInQuickfixVisual()<CR>]],
        { noremap = true, silent = true }
    )
end

-- Autocommand to set up keymaps when entering quickfix buffer
vim.api.nvim_create_autocmd("FileType", {
    pattern = "qf",
    callback = setup_quickfix_keymaps,
})


vim.keymap.set("n", "<", "v<<Esc>", { remap = true })
vim.keymap.set("n", ">", "v><Esc>", { remap = true })

keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)
keymap("x", "<", "<gv", opts)
keymap("x", ">", ">gv", opts)

if not vim.g.vscode then
    -- resize, swap
    vim.keymap.set('n', '<leader><leader>k', require('smart-splits').swap_buf_left)
    vim.keymap.set('n', '<leader><leader>h', require('smart-splits').swap_buf_down)
    vim.keymap.set('n', '<leader><leader>t', require('smart-splits').swap_buf_up)
    vim.keymap.set('n', '<leader><leader>n', require('smart-splits').swap_buf_right)

    vim.keymap.set("n", "<leader>hi", function()
        local result = vim.treesitter.get_captures_at_cursor()
        print("Treesitter: " .. vim.inspect(result))
        local syntax_id = vim.fn.synID(vim.fn.line("."), vim.fn.col("."), 1)
        local syntax_name = vim.fn.synIDattr(syntax_id, "name")
        local syntax_linked = vim.fn.synIDattr(vim.fn.synIDtrans(syntax_id), "name")
        print(string.format("Syntax: '%s' -> '%s'", syntax_name, syntax_linked))
    end, { desc = "Show highlight group under cursor" })

    keymap("n", "<C-z>", "<cmd>red<CR>", opts)
    keymap("n", "<D-z>", "<cmd>red<CR>", opts)

    keymap("x", "<C-c>", "y", opts)
    keymap("x", "<D-c>", "y", opts)
    keymap("n", "q", "<cmd>wq<CR>", opts)
    keymap("n", "Q", "<cmd>quitall<CR>", opts)

    keymap("n", "<C-A>", "ggVG", opts)
    keymap("n", "<A-a>", "ggVG", opts)
    keymap("n", "<D-a>", "ggVG", opts)

    -- Visual --
    -- Stay in indent mode

    -- Treesitter
    keymap("n", "<D-r>", "<cmd>Telescope live_grep<CR>", opts)
    keymap("n", "<A-r>", "<cmd>Telescope live_grep<CR>", opts)

    vim.keymap.set("n", "<c-s-b>", function()
        require("telescope.builtin").buffers({
            preview = false,
        })
    end, opts)

    keymap("n", "<D-S-p>", "<Cmd>Telescope buffers<CR>", opts)
    vim.keymap.set("n", "s/", function()
        require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
            sorting_strategy = "ascending",
            layout_config = {
                height = 0.7,
                width = 0.7,
                prompt_position = "top",
            },
            winblend = 10,
            previewer = false,
        }))
    end, { desc = "[/] Fuzzily search in current buffer]" })

    keymap("n", "<A-S-p>", "<Cmd>Telescope buffers<CR>", opts)
    vim.keymap.set("n", "s/", function()
        require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
            sorting_strategy = "ascending",
            layout_config = {
                height = 0.7,
                width = 0.7,
                prompt_position = "top",
            },
            winblend = 10,
            previewer = false,
        }))
    end, { desc = "[/] Fuzzily search in current buffer]" })

    keymap("n", "<leader>r", "<Cmd>SessionLoad<CR>", opts)
    keymap("n", "<leader>l", "<Cmd>Telescope persisted<CR>", opts)

    -- Visual Block --
    -- Move text up and down
    -- keymap("x", "<A-k>", ":move '>+1<CR>gv-gv", opts)
    -- keymap("x", "<A-i>", ":move '<-2<CR>gv-gv", opts)

    -- keymap("x", "<C-k>", ":move '>+1<CR>gv-gv", opts)
    -- keymap("x", "<C-i>", ":move '<-2<CR>gv-gv", opts)

    -- keymap("i", "<C-v>", "<Esc>p", opts)
    keymap("i", "<D-v>", "<Esc>p", opts)

    -- keymap("n", "<C-B>", ":NvimTreeToggleNoFocus<CR>", opts)
    -- keymap("n", "<C-B>", ":Telescope finder<CR>", opts)

    -- keymap("n", "<A-n>", ":Telescope file_browser path=%:p:h select_buffer=true<CR>", opts)
    keymap(
        "n",
        "<A-n>",
        "<cmd>lua require('telescope').extensions.file_browser.file_browser(require('telescope.themes').get_dropdown())<CR>",
        opts
    )

    -- keymap("n", "<C-/>", "<cmd>gcc<CR>", opts)
    -- keymap("x", "<C-/>", "<Plug>(comment_toggle_linewise_current)", opts)
    -- keymap("n", "<C-/>", "<Plug>(comment_toggle_linewise_current)", opts)
    -- keymap("v", "<C-/>", "<Plug>(comment_toggle_linewise_visual)", opts)
    -- keymap("v", "<C-_>", "<Plug>(comment_toggle_linewise_visual)", opts)
    -- What next? between tabs of current buffer.
    keymap("n", "<leader>1", "1gt", opts)
    keymap("n", "<leader>2", "2gt", opts)
    keymap("n", "<leader>3", "3gt", opts)
    keymap("n", "<leader>4", "4gt", opts)
    keymap("n", "<leader>5", "5gt", opts)
    keymap("n", "<leader>6", "6gt", opts)
    keymap("n", "<leader>7", "7gt", opts)
    keymap("n", "<leader>8", "8gt", opts)
    keymap("n", "<leader>9", "9gt", opts)

    -- cmp completion

    -- Select items in dropdown list from suggestions/cmp
    -- vim.keymap.set("c", "<M-k>", "<cmd>lua require('cmp').mapping.select_next_item()<cr>", opts)
    -- vim.keymap.set("o", "<M-k>", "<cmd>lua require('cmp').mapping.select_next_item()<cr>", opts)
    --
    -- vim.keymap.set("c", "<C-k>", "<cmd>lua require('cmp').mapping.select_next_item()<cr>", { silent = true })
    -- vim.keymap.set("o", "<C-k>", "<cmd>lua require('cmp').mapping.select_next_item()<cr>", { silent = true })
    --
    -- vim.keymap.set("c", "<C-i>", "<cmd>lua require('cmp').mapping.select_prev_item()<cr>", { silent = true })
    -- vim.keymap.set("o", "<C-i>", "<cmd>lua require('cmp').mapping.select_prev_item()<cr>", { silent = true })
    --
    -- What next? now? up and down in dropdown list.
    -- keymap("c", "<M-i>", "<C-p>", opts)
    -- keymap("o", "<M-i>", "<C-p>", opts)
    -- keymap("c", "<M-k>", "<C-n>", opts)
    -- keymap("o", "<M-k>", "<C-n>", opts)

    -- Next and previous problems.
    -- keymap("n", "<C-n>", "<Cmd>lua require('illuminate').goto_next_reference()<cr>", opts)
    keymap("n", "<C-p>", "<Cmd>lua require('illuminate').goto_prev_reference()<cr>", opts)
    keymap("n", "<Bslash>", "<Cmd>lua vim.diagnostic.goto_next()<cr>", opts)
    -- keymap("n", "<|>", "<Cmd>lua vim.diagnostic.goto_prev()<cr>", opts)

    -- save current file.
    -- keymap("n", "<C-s>", "<cmd>w<CR>", opts)
    keymap("n", "<D-s>", "<cmd>w<CR>", opts)

    -- Telescope
    keymap(
        "n",
        "<C-p>",
        '<cmd>lua require("telescope.builtin").find_files(require"telescope.themes".get_dropdown({previewer=true}))<CR>',
        opts
    )
    keymap(
        "v",
        "<A-p>",
        '<cmd>lua require("telescope.builtin").find_files(require"telescope.themes".get_dropdown({previewer=true}))<CR>',
        opts
    )

    keymap(
        "i",
        "<A-p>",
        '<cmd>lua require("telescope.builtin").find_files(require"telescope.themes".get_dropdown({previewer=true}))<CR>',
        opts
    )
    keymap(
        "n",
        "<A-p>",
        '<cmd>lua require("telescope.builtin").find_files(require"telescope.themes".get_dropdown({previewer=true}))<CR>',
        opts
    )

    -- Lazy

    keymap("n", "<C-x>", "<cmd>Lazy<cr>", opts)

    -- Debugger
    keymap("n", "dp", "<cmd>GoBreakToggle<CR>", opts)

    keymap("i", "<F2>", '<cmd>lua require("renamer").rename()<cr>', opts)

    -- Renamer
    -- keymap("n", "rn", '<cmd>lua require("renamer").rename()<cr>', opts)

    keymap("n", "`", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
    keymap("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)

    keymap("n", "<leader>s", "<cmd>w<CR> <cmd>lua vim.lsp.buf.formatting()<CR>", opts)

    keymap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)

    keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)

    keymap("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)

    keymap("n", "gi", "<cmd>lua vim.lsp.bui.implementation()<CR>", opts)

    keymap("n", "rq", "viqp", opts)
    -- keymap("n", 'ri"', "viq<Esc>p", opts)

    keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
else
    keymap("n", "?", "/", opts)
    keymap("n", "T", "10k", opts)
    keymap("n", "H", "10j", opts)
    keymap("n", "`", "<cmd>lua require('vscode-neovim').action('editor.action.marker.next')<CR>", opts)
    keymap("n", "#", "<cmd>lua require('vscode-neovim').action('editor.action.quickFix')<CR>", opts)
    keymap("n", "@", "<cmd>lua require('vscode-neovim').action('editor.action.quickFix')<CR>", opts)

    keymap("n", "/", "<cmd>lua require('vscode-neovim').action('swiper.swiper')<CR>", opts)
    keymap("v", "/", "<cmd>lua require('vscode-neovim').action('swiper.swiper-word-at-cursor')<CR>", opts)
    keymap("x", "/", "<cmd>lua require('vscode-neovim').action('swiper.swiper-word-at-cursor')<CR>", opts)
    keymap("o", "/", "<cmd>lua require('vscode-neovim').action('swiper.swiper-word-at-cursor')<CR>", opts)
    keymap("n", "me", "<cmd>lua require('vscode-neovim').action('vscode-harpoon.editEditors')<CR>", opts)
    keymap("n", "ma", "<cmd>lua require('vscode-neovim').action('vscode-harpoon.addEditor')<CR>", opts)
    keymap("n", "<d-a>", "<cmd>lua require('vscode').action('vscode-harpoon.addEditor')<CR>", opts)
    keymap("n", "<leader>a", "<cmd>lua require('vscode-neovim').action('vscode-harpoon.addGlobalEditor')<CR>", opts)
    -- keymap("n", "<A-e>", "<cmd>lua require('vscode').action('vscode-harpoon.editorQuickPick')<CR>", opts)
    keymap("n", "<D-e>", "<cmd>lua require('vscode').action('vscode-harpoon.editEditors')<CR>", opts)
    keymap("n", "dy", "<cmd>lua require('vscode').action('vscode-harpoon.gotoEditor1')<CR>", opts)
    keymap("n", "do", "<cmd>lua require('vscode').action('vscode-harpoon.gotoEditor2')<CR>", opts)
    keymap("n", "du", "<cmd>lua require('vscode').action('vscode-harpoon.gotoEditor3')<CR>", opts)
    keymap("n", "d;", "<cmd>lua require('vscode').action('vscode-harpoon.gotoEditor4')<CR>", opts)

    keymap("n", "i4", "<cmd>lua require('vscode').action('vscode-harpoon.gotoEditor4')<CR>", opts)
    keymap("n", "i5", "<cmd>lua require('vscode').action('vscode-harpoon.gotoEditor5')<CR>", opts)
    keymap("n", "i6", "<cmd>lua require('vscode').action('vscode-harpoon.gotoEditor6')<CR>", opts)
    keymap("n", "i7", "<cmd>lua require('vscode').action('vscode-harpoon.gotoEditor7')<CR>", opts)

    keymap("n", "<leader>d", "<cmd>lua require('vscode-neovim').action('workbench.action.debug.start')<CR>", opts)
    keymap("n", "<leader>s", "<cmd>lua require('vscode-neovim').action('workbench.action.debug.stop')<CR>", opts)

    keymap("n", "dp", "<cmd>lua require('vscode-neovim').action('editor.debug.action.toggleBreakpoint')<CR>", opts)
    keymap("n", "gd", "<cmd>lua require('vscode-neovim').action('editor.action.revealDefinition')<CR>", opts)
    keymap("n", "gD", "<cmd>lua require('vscode-neovim').action('editor.action.revealDeclaration')<CR>", opts)
    keymap("n", "gi", "<cmd>lua require('vscode-neovim').action('editor.action.goToImplementation')<CR>", opts)
    keymap("n", "gr", "<cmd>lua require('vscode-neovim').action('references-view.findReferences')<CR>", opts)
    keymap("n", "rn", "<cmd>lua require('vscode-neovim').action('editor.action.rename')<CR>", opts)
    keymap("n", "ga", "<cmd>lua require('vscode-neovim').action('editor.action.rename')<CR>", opts)
end

keymap("c", "<C-i>", "", opts)
-- keymap("c", "gi", "", opts)

-- vim.keymap.set("o", "<tab>", "<C-z>", { silent = false })

-- keymap("n", "L", "g_", opts)
-- keymap("v", "L", "g_", opts)
-- keymap("x", "L", "g_", opts)

local function ChangeWorkingDir()
    vim.cmd([[cd %:h]])
    vim.notify(vim.fn.getcwd(), vim.log.levels.INFO, {
        title = "Buffer Locate",
    })
end

vim.keymap.set("n", "cd", ChangeWorkingDir, { silent = true })
vim.keymap.set("n", "<leader>cd", ChangeWorkingDir, { silent = true })

-- Lua
if not vim.g.vscode then
    vim.keymap.set("n", "<leader>xx", function()
        require("trouble").toggle()
    end)
    vim.keymap.set("n", "<leader>xw", function()
        require("trouble").toggle("workspace_diagnostics")
    end)
    vim.keymap.set("n", "<leader>xd", function()
        require("trouble").toggle("document_diagnostics")
    end)
    vim.keymap.set("n", "<leader>qf", function()
        require("trouble").toggle("quickfix")
    end)
    vim.keymap.set("n", "<leader>xl", function()
        require("trouble").toggle("loclist")
    end)
    vim.keymap.set("n", "gR", function()
        require("trouble").toggle("lsp_references")
    end)
end

vim.cmd([[
let g:VM_maps = {}
let g:VM_maps['Find Under']         = '<C-d>'           " replace C-n
let g:VM_maps['Find Subword Under'] = '<C-d>'           " replace visual C-n
let g:EasyMotion_space_jump_first = 1

let g:EasyMotion_verbose = 0
]])
vim.keymap.set('n', '<CR>', 'm`O<Esc>t``')
vim.api.nvim_set_keymap('n', '+', ':lua vim.api.nvim_command("normal! \\22")<CR>', { noremap = true, silent = true })
keymap("n", "P", "<CR><C-w>p", opts)

vim.keymap.set({ "o" }, "p", '<cmd>lua require("various-textobjs").anyQuote("inner")<CR>')

vim.keymap.set({ "o" }, "w", '<cmd>lua require("various-textobjs").anyBracket("inner")<CR>')

vim.keymap.set("v", "n", "<cmd>lua require('spider').motion('e')<CR>")
vim.keymap.set("x", "n", "<cmd>lua require('spider').motion('e')<CR>")
vim.keymap.set("n", "o", "<cmd>lua require('spider').motion('w')<CR>")
vim.keymap.set("n", "n", "<cmd>lua require('spider').motion('w')<CR>")
vim.keymap.set("o", "o", "<cmd>lua require('spider').motion('w')<CR>")

vim.keymap.set("n", "co", "ce", { remap = true })

vim.keymap.set("o", "aw", "ab", { noremap = true })
vim.keymap.set("o", "io", "w", { noremap = true })
vim.keymap.set("o", "iw", "ib", { noremap = true })
vim.keymap.set("o", "ilp", "ilq", { noremap = true })
vim.keymap.set("x", "ip", "iq", { remap = true })
vim.keymap.set("x", "iw", "ib", { remap = true })
vim.keymap.set("x", "dp", "dq", { remap = true })

vim.keymap.set("n", "inp", "vinqda", { remap = true })
vim.keymap.set("n", "inw", "vinbda", { remap = true })
vim.keymap.set("n", "iw", "cib", { remap = true })
vim.keymap.set("n", "mdw", "mdb", { remap = true })

-- OR in one mapping
vim.keymap.set("n", "io", "c<cmd>lua require('spider').motion('e')<CR>")
vim.keymap.set("n", "co", "c<cmd>lua require('spider').motion('e')<CR>")
vim.keymap.set("n", "eo", "d<cmd>lua require('spider').motion('e')<CR>")

keymap("n", '"', ".", opts)
keymap("n", ".", "v", opts)
