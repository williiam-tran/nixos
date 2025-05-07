local fn = vim.fn
-- Automatically install packer
-- local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
	PACKER_BOOTSTRAP = fn.system({
		"git",
		"clone",
		"--depth",
		"1",
		"https://github.com/wbthomason/packer.nvim",
		install_path,
	})
	print("Installing packer close and reopen Neovim...")
	vim.cmd([[packadd packer.nvim]])
end

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]])

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
	return
end

-- Have packer use a popup window
packer.init({
	display = {
		open_fn = function()
			return require("packer.util").float({ border = "rounded" })
		end,
	},
})

-- Install your plugins here
return packer.startup(function(use)
	-- My plugins here
	use("wbthomason/packer.nvim") -- Have packer manage itself
	use("nvim-lua/popup.nvim") -- An implementation of the Popup API from vim in Neovim
	use("nvim-lua/plenary.nvim") -- Useful lua functions used ny lots of plugins
	-- use "jiangmiao/auto-pairs" -- Autopairs, integrates with both cmp and treesitter
	use({
		"windwp/nvim-autopairs",
		config = function()
			require("nvim-autopairs").setup({})
		end,
	})

	use("justinmk/vim-sneak")

	use({
		"terrortylor/nvim-comment",
		config = function()
			require("nvim_comment").setup()
		end,
	})

	use("folke/neodev.nvim")

	use("nathom/filetype.nvim")
	use("rstacruz/vim-closer") -- Closes the current buffer
	use("akinsho/bufferline.nvim")
	use("kyazdani42/nvim-web-devicons")

	-- NvimTree
	use({
		"kyazdani42/nvim-tree.lua",
		requires = {
			"kyazdani42/nvim-web-devicons", -- optional, for file icon
		},
		tag = "nightly", -- optional, updated every week. (see issue #1193)
	})

	use("moll/vim-bbye")
	use({
		"ahmedkhalf/project.nvim",
	})
	use("lewis6991/impatient.nvim")
	use("goolord/alpha-nvim")
	use("antoinemadec/FixCursorHold.nvim") -- This is needed to fix lsp doc highlight
	use("folke/which-key.nvim")

	-- Colorschemes
	use("lunarvim/darkplus.nvim")
	use("tomasiser/vim-code-dark")

	-- color for css.
	use("folke/lsp-colors.nvim")
	use("chrisbra/colorizer")
	use("norcalli/nvim-colorizer.lua")

	-- cmp plugns
	use("hrsh7th/nvim-cmp") -- The completion plugin
	use("hrsh7th/cmp-buffer") -- buffer completions
	use("hrsh7th/cmp-path") -- path completions
	-- use "hrsh7th/cmp-cmdline" -- cmdline completions
	-- use "saadparwaiz1/cmp_luasnip" -- snippet completions
	use("hrsh7th/cmp-nvim-lsp")

	-- snippets
	use("L3MON4D3/LuaSnip") --snippet engine
	use("rafamadriz/friendly-snippets") -- a bunch of snippets to use

	-- LSP
	use({
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"neovim/nvim-lspconfig",
	})

	use("lukas-reineke/lsp-format.nvim")

	-- use "tamago324/nlsp-settings.nvim" -- language server settings defined in json for
	use("brymer-meneses/grammar-guard.nvim") -- grammar guard
	use("jose-elias-alvarez/null-ls.nvim") -- for formatters and linters

	use("RRethy/vim-illuminate")

	-- Telescope
	use("nvim-telescope/telescope.nvim")

	-- use {
	-- "nvim-telescope/telescope-media-files.nvim",
	-- module = "telescope",
	-- after = "telescope.nvim",
	-- config = function()
	-- require('telescope').load_extension('media_files')
	-- end
	-- }

	-- Treesitter
	use({
		"nvim-treesitter/nvim-treesitter",
		run = ":TSUpdate",
	})

	require("nvim-treesitter.install").compilers = { "clang", "gcc" }

	use("nvim-treesitter/nvim-treesitter-textobjects")
	use("JoosepAlviste/nvim-ts-context-commentstring")

	-- Git
	use("lewis6991/gitsigns.nvim")

	-- -- coc-nvims
	use({ "neoclide/coc.nvim", branch = "release" })

	-- airline
	use("vim-airline/vim-airline")
	use("vim-airline/vim-airline-themes")
	use("ryanoasis/vim-devicons")
	use("edkolev/tmuxline.vim")
	use({
		"github/copilot.vim",
		branch = "release",
	})

	use("tpope/vim-surround")

	-- nerdtree
	use("tpope/vim-eunuch")

	-- notification
	use("rcarriga/nvim-notify")

	-- dashboard
	use("mhinz/vim-startify")

	-- terminal
	use("akinsho/toggleterm.nvim")

	-- Todo plugins

	use("unblevable/quick-scope")
	use("tpope/vim-repeat")
	use("karb94/neoscroll.nvim")

	-- tab out of parenthesis
	use({
		"abecodes/tabout.nvim",
	})

	-- renamer
	use({
		"filipdutescu/renamer.nvim",
		branch = "master",
		requires = { { "nvim-lua/plenary.nvim" } },
	})

	-- syntax highlighting
	use("sheerun/vim-polyglot")

	-- Git plugin for neovim
	use("tpope/vim-fugitive")

	-- Debugger for neovim
	use("ycm-core/YouCompleteMe")
	-- use "puremourning/vimspector"

	-- Debugger management
	use("mfussenegger/nvim-jdtls")
	use({
		"mfussenegger/nvim-dap",
		-- event = "BufWinEnter",
		-- config = function()
		--     require("lvim.core.dap").setup()
		-- end,
		-- disable = not lvim.builtin.dap.active,
	})
	use({
		"Pocco81/dap-buddy.nvim",
		branch = "dev",
		-- event = "BufWinEnter",
		-- event = "BufRead",
		-- disable = not lvim.builtin.dap.active,
	})

	-- Put this at the end after all plugins
	if PACKER_BOOTSTRAP then
		require("packer").sync()
	end
end)
