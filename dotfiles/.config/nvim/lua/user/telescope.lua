local telescope = require("telescope")
local actions = require("telescope.actions")
local fb_actions = require("telescope").extensions.file_browser.actions
-- local lga_actions = require("telescope-live-grep-args.actions")
local path_actions = require("telescope_insert_path")
-- local persisted_actions = require("telescope._extensions.persisted.actions")

local function create_and_focus(prompt_bufnr)
    local current_picker = require("telescope.actions.state").get_current_picker(prompt_bufnr)
    fb_actions.create(prompt_bufnr)
    -- Wait a bit for the file to be created
    vim.defer_fn(function()
        current_picker:refresh()
        -- Move the selection to the last item (newly created file)
        current_picker:set_selection(current_picker.manager:num_results())
    end, 100)
end

local function create_from_prompt_and_focus(prompt_bufnr)
    local current_picker = require("telescope.actions.state").get_current_picker(prompt_bufnr)
    fb_actions.create_from_prompt(prompt_bufnr)
    -- Wait a bit for the file to be created
    vim.defer_fn(function()
        current_picker:refresh()
        -- Move the selection to the last item (newly created file)
        current_picker:set_selection(current_picker.manager:num_results())
    end, 100)
end

telescope.setup({
    extensions = {
        persisted = {
            initial_mode = "normal",
            sorting_strategy = "ascending",
            layout_config = {
                height = 0.5,
                width = 0.5,
                prompt_position = "top",
            },
        },
        live_grep_args = {
            previewer = true,
            auto_quoting = false, -- enable/disable auto-quoting
            -- define mappings, e.g.
            -- ... also accepts theme settings, for example:
            theme = "dropdown",                -- use dropdown theme
            -- theme = "ivy",
            layout_config = { mirror = true }, -- mirror preview pane
            file_ignore_patterns = {
                "lazy-lock.json",
                "node_modules",
                "e2e",
            },
        },
        file_browser = {
            path = vim.fn.expand("%:p:h"),
            previewer = false,
            initial_mode = "normal",
            select_buffer = true,
            files = false,
            theme = "ivy",
            -- disables netrw and use telescope-file-browser in its place
            hijack_netrw = false,
            mappings = {
                ["i"] = {
                    ["<A-n>"] = create_and_focus,
                    ["<CR>"] = create_from_prompt_and_focus,
                    -- ["<A-r>"] = fb_actions.rename,
                    -- ["<A-m>"] = fb_actions.move,
                    -- ["<A-y>"] = fb_actions.copy,
                    -- ["<A-d>"] = fb_actions.remove,
                    -- ["<C-o>"] = fb_actions.open,
                    -- ["<C-g>"] = fb_actions.goto_parent_dir,
                    -- ["<C-e>"] = fb_actions.goto_home_dir,
                    -- ["<C-w>"] = fb_actions.goto_cwd,
                    -- ["<C-t>"] = fb_actions.change_cwd,
                    -- ["<C-f>"] = fb_actions.toggle_browser,
                    -- ["<C-h>"] = fb_actions.toggle_hidden,
                    -- ["<C-s>"] = fb_actions.toggle_all,
                    -- ["<bs>"] = fb_actions.backspace,
                },
                ["n"] = {
                    ["o"] = fb_actions.create,
                    ["r"] = fb_actions.rename,
                    ["m"] = fb_actions.move,
                    ["y"] = fb_actions.copy,
                    ["d"] = fb_actions.remove,
                    ["b"] = fb_actions.goto_parent_dir,
                    -- ["h"] = fb_actions.goto_home_dir,
                    -- ["w"] = fb_actions.goto_cwd,
                    -- ["t"] = fb_actions.change_cwd,
                    -- ["f"] = fb_actions.toggle_browser,
                    -- ["s"] = fb_actions.toggle_all,
                },
            },
        },
        media_files = {
            -- filetypes whitelist
            -- defaults to {"png", "jpg", "mp4", "webm", "pdf"}
            filetypes = { "png", "webp", "jpg", "jpeg" },
            find_cmd = "rg", -- find command (defaults to `fd`)
            on_enter = function(filepath)
                vim.fn.setreg("+", filepath)
                vim.notify("The image path has been copied to system clipboard!")
            end,
        },
        fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mod = "smart_case",
        },
    },
    defaults = {
        path_display = {
            filename_first = {
                reverse_directories = true,
            },
        },

        initial_mode = "insert",
        file_ignore_patterns = { "node_modules", ".gitignore", ".ignore", ".git", "e2e" },
        -- fzf = {
        -- 	vimgrep_arguments = {
        -- 		"rg",
        -- 		"--color=never",
        -- 		"--no-heading",
        -- 		"--with-filename",
        -- 		"--smart-case",
        -- 	},
        -- },

        mappings = {
            i = {
                -- ["<Esc>"] = actions.close,
                ["<c-d>"] = require("telescope.actions").delete_buffer,
                ["<D-q>"] = function(prompt_bufnr)
                    local picker = require("telescope.actions.state").get_current_picker(prompt_bufnr)
                    -- local selection = picker:get_selection()
                    local results = picker:get_multi_selection() -- Get selected results

                    -- Prepare the quickfix list
                    local qflist = {}
                    for _, entry in ipairs(results) do
                        table.insert(qflist, {
                            filename = entry.filename,
                            lnum = entry.lnum,
                            text = entry.text,
                        })
                    end

                    -- Set the quickfix list
                    vim.fn.setqflist(qflist)
                    -- Optionally, open the quickfix list
                    vim.cmd("copen")
                end,
                ["<C-q>"] = function(prompt_bufnr)
                    local picker = require("telescope.actions.state").get_current_picker(prompt_bufnr)
                    -- local selection = picker:get_selection()
                    local results = picker:get_multi_selection() -- Get selected results

                    -- Prepare the quickfix list
                    local qflist = {}
                    for _, entry in ipairs(results) do
                        table.insert(qflist, {
                            filename = entry.filename,
                            lnum = entry.lnum,
                            text = entry.text,
                        })
                    end

                    -- Set the quickfix list
                    vim.fn.setqflist(qflist)
                    -- Optionally, open the quickfix list
                    vim.cmd("copen")
                end,
            },
            n = {
                ["r"] = path_actions.insert_relpath_normal,
                ["a"] = path_actions.insert_abspath_normal,
                ["d>"] = require("telescope.actions").delete_buffer,
                ["Esc"] = actions.close,
                ["q"] = function(prompt_bufnr)
                    local picker = require("telescope.actions.state").get_current_picker(prompt_bufnr)
                    -- local selection = picker:get_selection()
                    local results = picker:get_multi_selection() -- Get selected results

                    -- Prepare the quickfix list
                    local qflist = {}
                    for _, entry in ipairs(results) do
                        table.insert(qflist, {
                            filename = entry.filename,
                            lnum = entry.lnum,
                            text = entry.text,
                        })
                    end

                    -- Set the quickfix list
                    vim.fn.setqflist(qflist)
                    -- Optionally, open the quickfix list
                    vim.cmd("copen")
                end,
            },
        },
        layout_config = {
            horizontal = {
                width = 0.8,
                height = 0.8,
                preview_cutoff = 20,
                width_padding = 0.04,
                height_padding = 0.01,
                preview_width = 0.8,
                preview_height = 0.8,
                prompt_position = "top",
            },
            vertical = {
                preview_cutoff = 20,
                width_padding = 0.05,
                width = 0.8,
                height = 0.8,
                preview_height = 0.8,
            },
        },
    },
    pickers = {
        live_grep = {
            previewer = true,
            theme = "dropdown", -- use dropdown theme
            -- layout_config = { mirror = true }, -- mirror preview pane
        },
        commands = {
            previewer = false,
        },
        file_browser = {
            previewer = false,
        },

        buffers = {
            theme = "dropdown",
            previewer = false,
            show_all_buffers = true,
            sort_mru = true,
            mappings = {
                n = {
                    ["d"] = "delete_buffer",
                    ["<A-d>"] = "delete_buffer",
                },
                i = {
                    ["<c-d>"] = "delete_buffer",
                    ["<A-d>"] = "delete_buffer",
                },
            },
            initial_mode = "normal",
        },
        find_files = {
            hidden = true,
            layout_config = {
                height = 1,
                width = 1,
                prompt_position = "top",
            },
            previewer = true,
            find_command = {
                "rg",
                "--files",
                "--glob",
                "!{.git/*,.svelte-kit/*,target/*,node_modules/*}",
                "--path-separator",
                "/",
            },
            mappings = {
                n = {
                    ["<Tab>"] = actions.select_default,
                    ["<C-g>"] = actions.select_vertical,
                },
                i = {
                    ["<Tab>"] = actions.select_default,
                    ["<C-g>"] = actions.select_vertical,
                },
            },
        },
    },
})
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

vim.keymap.set("n", "gl", function()
    require("various-textobjs").url()
    local foundURL = vim.fn.mode():find("v")
    if foundURL then
        vim.cmd.normal('"zy')
        local url = vim.fn.getreg("z")
        vim.ui.open(url)
    else
        -- find all URLs in buffer
        local urlPattern = require("various-textobjs.charwise-textobjs").urlPattern
        local bufText = table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), "\n")
        local urls = {}
        for url in bufText:gmatch(urlPattern) do
            table.insert(urls, url)
        end
        if #urls == 0 then
            return
        end

        -- Use Telescope picker
        pickers
            .new({}, {
                prompt_title = "URLs in Buffer",
                finder = finders.new_table({
                    results = urls,
                }),
                sorter = conf.generic_sorter({}),
                initial_mode = "normal",
                sorting_strategy = "ascending",
                layout_config = {
                    height = 0.5,
                    width = 0.5,
                    prompt_position = "top",
                },
                previewer = false,
                attach_mappings = function(prompt_bufnr, map)
                    actions.select_default:replace(function()
                        actions.close(prompt_bufnr)
                        local selection = action_state.get_selected_entry()
                        vim.ui.open(selection[1])
                    end)
                    return true
                end,
            })
            :find()
    end
end, { desc = "URL Opener" })

require("telescope").load_extension("fzf")
require("telescope").load_extension("file_browser")
require("telescope").load_extension("live_grep_args")
require("telescope").load_extension("ui-select")
require("telescope").load_extension("noice")
