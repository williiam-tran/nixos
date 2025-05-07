require('kitty-scrollback').setup({
    {
        status_window = {
            enabled = true,
            autoclose = false
        },
        kitty_get_text = {
            ansi = true,
            -- Choices: screen, all, first_cmd_output_on_screen, last_cmd_output, last_non_empty_output, last_visited_cmd_output, selection
            extent = 'last_cmd_output',
        },
        -- boolean? if true execute :checkhealth kitty-scrollback and skip setup
        paste_window = {
            hide_footer = false,
            -- integer? The winblend setting of the window, see :help winblend
            winblend = 0,
            -- yank_register = { '*' },
            yank_register_enabled = true,
        },
    },
})
