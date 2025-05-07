vim.g.nvim_tree_respect_buf_cwd = 1

vim.api.nvim_create_user_command(
    'NvimTreeToggleNoFocus',
    function()
        require 'nvim-tree.api'.tree.toggle({ focus = false })
    end,
    {}
)

require 'nvim-tree'.setup {
    auto_reload_on_write = true,
    update_focused_file = {
        enable = true,
        update_cwd = true
    },
    disable_netrw = false,
    hijack_cursor = false,
    hijack_netrw = true,
    hijack_unnamed_buffer_when_opening = false,
    ignore_buffer_on_setup = false,
    open_on_tab = false,
    sort_by = "name",
    update_cwd = true,
    view = {
        width = 30,
        hide_root_folder = false,
        side = "left",
        preserve_window_proportions = false,
        number = true,
        relativenumber = true,
        signcolumn = "yes",
        mappings = {
            custom_only = false,
            list = {
                -- user mappings go here
                { key = "u",                action = "dir_up" },
                { key = { "<space>", "o" }, action = "edit",       mode = "n" },
                { key = "t",                action = "tabnew" },
                { key = "<space>",          action = "close_node" },
                { key = "<space>",          action = "preview" },
                { key = "r",                action = "full_rename" },
                { key = "n",                action = "create" },
                { key = "R",                action = "refresh" },
            },
        },
    },
}
