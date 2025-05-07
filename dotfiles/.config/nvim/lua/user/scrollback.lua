require('kitty-scrollback').setup({
    {
        status_window = {
            enabled = false,
            autoclose = true
        },
        kitty_get_text = {
            ansi = true,
            -- Choices: screen, all, first_cmd_output_on_screen, last_cmd_output, last_non_empty_output, last_visited_cmd_output, selection
            extent = 'last_non_empty_output',
        },
        -- boolean? if true execute :checkhealth kitty-scrollback and skip setup
        paste_window = {
            yank_register = { '*' },
            yank_register_enabled = true,
            post_yank_hook = function()
                -- Force a clipboard sync after yanking
                vim.fn.system('xclip -selection clipboard', vim.fn.getreg('+'))
            end,
        },
    },
})
