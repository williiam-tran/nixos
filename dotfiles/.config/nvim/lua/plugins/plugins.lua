return {
    -- lazy.nvim
    { 'mrjones2014/smart-splits.nvim', build = './kitty/install-kittens.bash' },
    { "chrisgrieser/nvim-spider",      lazy = true },
    {
        "lewis6991/gitsigns.nvim"
    },
    {
        "NeogitOrg/neogit",
        dependencies = {
            "nvim-lua/plenary.nvim",  -- required
            "sindrets/diffview.nvim", -- optional - Diff integration

            -- Only one of these is needed.
            "nvim-telescope/telescope.nvim", -- optional
            "ibhagwan/fzf-lua",              -- optional
            "echasnovski/mini.pick",         -- optional
        },
        cmd = "Neogit",
        lazy = false,
        config = false
    },

    {
        'mikesmithgh/kitty-scrollback.nvim',
        enabled = true,
        lazy = true,
        cmd = { 'KittyScrollbackGenerateKittens', 'KittyScrollbackCheckHealth', 'KittyScrollbackGenerateCommandLineEditing' },
        event = { 'User KittyScrollbackLaunch' },
        version = '*', -- latest stable version, may have breaking changes if major version changed
    },
    {
        "declancm/cinnamon.nvim",
        version = "*", -- use latest release
        opts = {
            -- change default options here
        },
    },
    "windwp/nvim-ts-autotag",
    {
        "pmizio/typescript-tools.nvim",
        dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
        opts = {},
    },
    {
        "folke/ts-comments.nvim",
        opts = {},
        event = "VeryLazy",
        enabled = vim.fn.has("nvim-0.10.0") == 1,
    },
    {
        "olimorris/persisted.nvim",
        lazy = false, -- make sure the plugin is always loaded at startup
        config = true,
    },
    { 'echasnovski/mini.surround', version = false },
    { 'echasnovski/mini.comment',  version = '*' },
    {
        "folke/lazydev.nvim",
        ft = "lua", -- only load on lua files
        opts = {
            library = {
                -- See the configuration section for more details
                -- Load luvit types when the `vim.uv` word is found
                { path = "luvit-meta/library", words = { "vim%.uv" } },
            },
        },
    },

    { "Bilal2453/luvit-meta",                   lazy = true }, -- optional `vim.uv` typings

    {
        "hrsh7th/nvim-cmp",
        opts = function(_, opts)
            opts.sources = opts.sources or {}
            table.insert(opts.sources, {
                name = "lazydev",
                group_index = 0, -- set group index to 0 to skip loading LuaLS completions
            })
        end,
    },
    -- {
    --     "folke/flash.nvim",
    --     event = "VeryLazy",
    --     keys = {
    --         {
    --             "s",
    --             mode = { "n", "x", "o" },
    --             function()
    --                 require("flash").treesitter()
    --             end,
    --             desc = "Flash Treesitter",
    --         },
    --     },
    -- },
    {
        "echasnovski/mini.files",
        version = "*",
        dependencies = {
            { "echasnovski/mini.icons", version = false },
        },
    },

    "rlane/pounce.nvim",
    {
        "stevearc/oil.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if prefer nvim-web-devicons
    },
    {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        dependencies = { "nvim-lua/plenary.nvim" },
    },
    { "nvim-telescope/telescope-ui-select.nvim" },
    "kiyoon/telescope-insert-path.nvim",
    { "junegunn/fzf",                             dir = "~/.fzf", build = "./install --all" },
    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            "nvim-telescope/telescope-live-grep-args.nvim",
        },
        config = function()
            require("telescope").setup({})
            require("telescope").load_extension("live_grep_args")
        end,
    },
    {
        "mg979/vim-visual-multi",
        priority = 1000,
        event = { "VimEnter" },
    },
    {
        "nvim-lua/plenary.nvim", -- ful lua functions used ny lots of plugins
        -- lazy = true,
    },

    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        opts = {},
        lazy = true,
    },

    -- around, inside, next, previous navigation
    {
        "chrisgrieser/nvim-various-textobjs",
        event = "UIEnter",
    },
    {
        "wellle/targets.vim",
        priority = 1000,
        event = { "VimEnter" },
    },
    {
        "https://github.com/chaoren/vim-wordmotion",
        lazy = false,
    },

    -- "nathom/filetype.nvim",
    "kyazdani42/nvim-web-devicons",
    "BurntSushi/ripgrep",
    "sharkdp/fd",
    -- colorscheme
    "Mofiqul/vscode.nvim",
    {
        "stevearc/dressing.nvim",
        opts = {},
    },

    {
        "hrsh7th/nvim-cmp", -- The completion plugin
        dependencies = {
            "onsails/lspkind.nvim",
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
            "VonHeikemen/lsp-zero.nvim",
            "L3MON4D3/LuaSnip",
        },
        event = { "InsertEnter", "CmdlineEnter" },
        opts = function(_, opts)
            opts.sources = opts.sources or {}
            table.insert(opts.sources, {
                name = "lazydev",
                group_index = 0, -- set group index to 0 to skip loading LuaLS completions
            })
        end,
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

    -- "brymer-meneses/grammar-guard.nvim",
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
            "nvim-lua/plenary.nvim",
            -- "nvim-telescope/telescope-media-files.nvim",
            -- event = "VeryLazy",
            -- lazy = true,
            -- module = "telescope",
            -- config = function()
            -- 	require("telescope").load_extension("media_files")
            -- end,
        },
        -- event = "VeryLazy",
        -- lazy = true,
    },

    {
        "nvim-telescope/telescope-file-browser.nvim",
        dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
    },

    {
        "folke/noice.nvim",
        commit = "d9328ef",
        opts = {},
        dependencies = {
            "MunifTanjim/nui.nvim",
            -- "rcarriga/nvim-notify",
        },
        event = "VeryLazy",
    },

    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },

    -- Treesitter
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",

        "nvim-treesitter/nvim-treesitter-textobjects",
        "JoosepAlviste/nvim-ts-context-commentstring",
        "RRethy/nvim-treesitter-textsubjects",
    },

    -- -- coc-nvims
    -- { "neoclide/coc.nvim", branch = "release" },

    -- airline
    -- {
    -- 	"vim-airline/vim-airline",
    -- 	event = "BufReadPre",
    -- },
    -- "vim-airline/vim-airline-themes",

    "ryanoasis/vim-devicons",

    {
        "tpope/vim-surround",
        event = "BufReadPre",
    },

    "tpope/vim-eunuch",
    -- "unblevable/quick-scope", -- highlight the first letter of the word you are searching for
    "tpope/vim-repeat",
    -- "karb94/neoscroll.nvim",
    -- {
    -- 	"ggandor/leap.nvim",
    -- 	config = function()
    -- 		require("leap").create_default_mappings()
    -- 	end,
    -- },

    -- tab out of parenthesis
    "abecodes/tabout.nvim",
    {
        "sheerun/vim-polyglot",
        -- event = { "BufReadPre" },
        lazy = true,
        event = "VeryLazy",
    },
}
