return {
    -- My plugins here
    {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        dependencies = { "nvim-lua/plenary.nvim" }
    },
    -- { 'ojroques/vim-oscyank',                     branch = 'main' },
    {
        'mikesmithgh/kitty-scrollback.nvim',
        enabled = true,
        lazy = true,
        cmd = { 'KittyScrollbackGenerateKittens', 'KittyScrollbackCheckHealth' },
        event = { 'User KittyScrollbackLaunch' },
    },
    {
        "m00qek/baleia.nvim",
        version = "*",
        config = function()
            vim.g.baleia = require("baleia").setup({})

            -- Command to colorize the current buffer
            vim.api.nvim_create_user_command("BaleiaColorize", function()
                vim.g.baleia.once(vim.api.nvim_get_current_buf())
            end, { bang = true })

            -- Command to show logs
            vim.api.nvim_create_user_command("BaleiaLogs", vim.g.baleia.logger.show, { bang = true })
        end,
    },
    "nvim-lua/popup.nvim",       -- An implementation of the Popup API from vim in Neovim
    {
        "nvim-lua/plenary.nvim", -- ful lua functions used ny lots of plugins
        -- lazy = true,
    },

    {
        "sindrets/diffview.nvim",
        event = { "VimEnter" },
        lazy = false,
    },

    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        opts = {},
        lazy = true,
    },

    {
        "wellle/targets.vim",
        priority = 1000,
        event = { "VimEnter" },
    },

    -- vscode
    {
        "vscode-neovim/vscode-neovim",
    },

    {
        "justinmk/vim-sneak",
        event = { "VimEnter" },
    },

    {
        "numToStr/Comment.nvim",
        opts = {
            -- add any options here
        },
        lazy = false,
    },

    "folke/neodev.nvim",

    "nathom/filetype.nvim",
    -- "akinsho/bufferline.nvim",
    "kyazdani42/nvim-web-devicons",

    {
        "kyazdani42/nvim-tree.lua",
        dependencies = {
            "kyazdani42/nvim-web-devicons", -- optional, for file icon
        },
        tag = "nightly",                    -- optional, updated every week. (see issue #1193)
    },

    "moll/vim-bbye",
    "ahmedkhalf/project.nvim",
    "lewis6991/impatient.nvim",
    "goolord/alpha-nvim",
    "antoinemadec/FixCursorHold.nvim", -- This is needed to fix lsp doc highlight
    "folke/which-key.nvim",

    -- Colorschemes
    -- {
    -- 	"lunarvim/darkplus.nvim",
    -- 	priority = 1000,
    -- 	event = "BufReadPre",
    -- },
    -- {
    -- 	"tomasiser/vim-code-dark",
    -- 	priority = 1000,
    -- 	event = "BufReadPre",
    -- 	config = function()
    -- 		vim.g["codedark_term256"] = 1
    -- 		vim.cmd([[
    --               colorscheme codedark
    -- 		  hi Comment guifg=#dbaf84
    -- 		  hi String guifg=#efa29b
    -- 		  hi! link Sneak Search
    -- 		  hi Search guibg=#658da1
    -- 		  let g:sneak#label = 1
    -- 		  let g:highlightedyank_highlight_in_visual = 0
    -- 		  ]])
    -- 	end,
    -- },

    {
        "stevearc/dressing.nvim",
        opts = {},
    },

    -- color for css.
    "folke/lsp-colors.nvim",
    "chrisbra/colorizer",
    "norcalli/nvim-colorizer.lua",

    -- cmp plugins
    {
        "hrsh7th/nvim-cmp", -- The completion plugin
        dependencies = {
            "hrsh7th/cmp-buffer",
            {
                "hrsh7th/cmp-path",
                event = { "InsertEnter", "CmdlineEnter" },
                lazy = false,
            },
            {
                "hrsh7th/cmp-cmdline",
                event = { "InsertEnter", "CmdlineEnter" },
                lazy = false,
            },
            {
                "hrsh7th/cmp-nvim-lsp",
                event = { "InsertEnter", "CmdlineEnter" },
                lazy = false,
            },

            "saadparwaiz1/cmp_luasnip",
            --
            -- {
            -- 	"L3MON4D3/LuaSnip", --snippet engine
            --              version = "v2.*",
            -- 	lazy = false,
            --              build = "make install_jsregexp"
            -- },
            "VonHeikemen/lsp-zero.nvim",
        },
        event = { "InsertEnter", "CmdlineEnter" },
        lazy = false,
    },

    -- snippets

    "rafamadriz/friendly-snippets", -- a bunch of snippets to use

    -- LSP
    {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "neovim/nvim-lspconfig",
    },

    "lukas-reineke/lsp-format.nvim",

    "brymer-meneses/grammar-guard.nvim",
    "jose-elias-alvarez/null-ls.nvim", -- for formatters and linters
    {
        "stevearc/conform.nvim",
        opts = {},
    },

    {
        "RRethy/vim-illuminate",
        lazy = true,
    },

    -- Telescope
    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            "nvim-telescope/telescope-media-files.nvim",
            event = "VeryLazy",
            lazy = true,
            module = "telescope",
            config = function()
                require("telescope").load_extension("media_files")
            end,
        },
        -- event = "VeryLazy",
        -- lazy = true,
    },

    {
        "folke/noice.nvim",
        event = "VeryLazy",
        opts = {},
        dependencies = {
            "MunifTanjim/nui.nvim",
        },
    },

    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },

    -- Treesitter
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",

        "nvim-treesitter/nvim-treesitter-textobjects",
        "JoosepAlviste/nvim-ts-context-commentstring",
    },

    "ryanoasis/vim-devicons",

    {
        "github/copilot.vim",
        branch = "release",
    },

    {
        "tpope/vim-surround",
        event = "BufReadPre",
    },

    {
        "junegunn/fzf",
        dir = "~/.fzf",
        build = "./install --all",
        lazy = false
    },

    -- {
    -- 	"haya14busa/incsearch.vim",
    -- 	priority = 1000,
    -- 	event = { "BufReadPre" },
    -- },

    -- nerdtree
    "tpope/vim-eunuch",

    -- dashboard
    "mhinz/vim-startify",

    {
        "easymotion/vim-easymotion",
        dependencies = {
            "haya14busa/incsearch.vim",
            "haya14busa/incsearch-easymotion.vim",
            "haya14busa/incsearch-fuzzy.vim",
        },

        priority = 1200,
        event = { "VimEnter" },
        lazy = false,
    },

    -- Todo plugins
    "unblevable/quick-scope", -- highlight the first letter of the word you are searching for
    "tpope/vim-repeat",
    "karb94/neoscroll.nvim",
    {
        "karb94/neoscroll.nvim",
        config = function()
            require('neoscroll').setup({
            })
        end
    },
    {
        "ggandor/leap.nvim",
        config = function()
            require("leap").create_default_mappings()
        end,
    },

    -- tab out of parenthesis
    "abecodes/tabout.nvim",
    {
        "filipdutescu/renamer.nvim",
        branch = "master",
        dependencies = { "nvim-lua/plenary.nvim" },
    },

    -- syntax highlighting
    {
        "sheerun/vim-polyglot",
        -- event = { "BufReadPre" },
        lazy = true,
        event = "VeryLazy",
    },

    -- Git plugin for neovim
    "tpope/vim-fugitive",

    -- Debugger for neovim
    -- "ycm-core/YouCompleteMe",
    --  "puremourning/vimspector"
}
