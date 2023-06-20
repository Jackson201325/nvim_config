local fn = vim.fn

local ensure_packer = function()
	local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
	if fn.empty(fn.glob(install_path)) > 0 then
		fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
		vim.cmd([[packadd packer.nvim]])
		return true
	end
	return false
end

vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
  augroup end
]])

local packer_bootstrap = ensure_packer()

local status_ok, packer = pcall(require, "packer")
if not status_ok then
	return
end

packer.startup(function(use)
	use("wbthomason/packer.nvim")

	-- My plugins here
	use("nvim-lua/plenary.nvim")
	use("nvim-lua/popup.nvim")

	-- Color scheme
	use("folke/tokyonight.nvim")

	-- Replacing surroundings
	use("tpope/vim-surround")

	-- CMP plugins
	use("hrsh7th/nvim-cmp") -- Autocompletion plugin
	use("hrsh7th/cmp-buffer") -- Autocompletion for buffers
	use("hrsh7th/cmp-path") -- Autocompletion for paths
	use("hrsh7th/cmp-cmdline") -- Autocompletion for cmdline
	use("hrsh7th/cmp-nvim-lsp")
	use("hrsh7th/cmp-nvim-lua")
	use("onsails/lspkind-nvim")

	-- snippets
	use("L3MON4D3/LuaSnip") -- Snippets plugin
	use("saadparwaiz1/cmp_luasnip") -- Autocompletion for snippets
	use("rafamadriz/friendly-snippets") -- Snippets collection

	-- LSP
	use("williamboman/mason.nvim")
	use("williamboman/mason-lspconfig.nvim")
	use("neovim/nvim-lspconfig")
	use("jose-elias-alvarez/null-ls.nvim")
	use("folke/neodev.nvim")

	-- LSP support
	use({ "glepnir/lspsaga.nvim", branch = "main" })
	use("jose-elias-alvarez/typescript.nvim")
	-- use("rust-lang/rust.vim")
	-- use("simrat39/rust-tools.nvim")
	use("mfussenegger/nvim-dap")
	use("leoluz/nvim-dap-go")
	-- use({
	-- 	"saecki/crates.nvim",
	-- 	tag = "v0.3.0",
	-- 	requires = { "nvim-lua/plenary.nvim" },
	-- 	config = function()
	-- 		require("crates").setup()
	-- 	end,
	-- })
	use("roobert/tailwindcss-colorizer-cmp.nvim")
	use({
		"olexsmir/gopher.nvim",
		requires = { -- dependencies
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
	})

	-- Telescope
	use("nvim-telescope/telescope.nvim")
	use("nvim-telescope/telescope-live-grep-args.nvim")
	use({
		"nvim-telescope/telescope-fzf-native.nvim",
		run = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
	})
	use("nvim-telescope/telescope-media-files.nvim")
	use("nvim-telescope/telescope-project.nvim")

	-- Coding
	use("windwp/nvim-ts-autotag")
	use("nvim-treesitter/nvim-treesitter", { run = ":TSUpdate" })
	use("nvim-treesitter/playground")
	use("JoosepAlviste/nvim-ts-context-commentstring")
	use("windwp/nvim-autopairs")
	use("tpope/vim-endwise")
	use("numToStr/Comment.nvim")
	use({
		"ahmedkhalf/project.nvim",
		config = function()
			require("project_nvim").setup({})
		end,
	})
	use({
		"cappyzawa/trim.nvim",
		config = function()
			require("trim").setup({})
		end,
	})
	use({
		"nvim-treesitter/nvim-treesitter-textobjects",
		after = "nvim-treesitter",
		requires = "nvim-treesitter/nvim-treesitter",
	})
	use({ "mg979/vim-visual-multi", branch = "master" })
	use("tpope/vim-repeat")
	use("m-demare/hlargs.nvim")

	-- UI
	use("lewis6991/gitsigns.nvim")
	use("xiyaowong/transparent.nvim")
	use("goolord/alpha-nvim")
	use("NvChad/nvim-colorizer.lua")
	use("folke/which-key.nvim")
	use("RRethy/vim-illuminate")
	use("kevinhwang91/nvim-hlslens")
	use({ "kevinhwang91/nvim-ufo", requires = "kevinhwang91/promise-async" })
	use({ "kevinhwang91/nvim-bqf", ft = "qf" })
	use({
		"junegunn/fzf",
		run = function()
			vim.fn["fzf#install"]()
		end,
	})
	use("luukvbaal/statuscol.nvim")

	-- Movement
	use("mbbill/undotree")
	use("ThePrimeagen/harpoon")
	use("christoomey/vim-tmux-navigator") -- Navigate between vim and tmux panes seamlessly
	use("ggandor/flit.nvim")
	use("ggandor/leap.nvim")

	-- Neo Tree
	use({
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v2.x",
		requires = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
			"MunifTanjim/nui.nvim",
		},
	})

	-- Toggle terminal
	use({
		"akinsho/toggleterm.nvim",
		tag = "*",
	})

	-- Bufferline
	use("akinsho/bufferline.nvim")

	-- Status line
	use("nvim-lualine/lualine.nvim")

	-- Copilot
	use("zbirenbaum/copilot.lua")
	use("zbirenbaum/copilot-cmp")

	-- Sessions Management
	use("olimorris/persisted.nvim")

	-- Indentation line
	use("lukas-reineke/indent-blankline.nvim")
	use("echasnovski/mini.indentscope")

	-- Delete buffer but not split
	use("echasnovski/mini.bufremove")

	-- Automatically set up your configuration after cloning packer.nvim
	-- Put this at the end after all plugins
	if packer_bootstrap then
		require("packer").sync()
	end
end)

-- Interesting plugins
-- use({ "kevinhwang91/nvim-ufo", requires = "kevinhwang91/promise-async" })
-- use("luukvbaal/statuscol.nvim")
-- use("simrat39/symbols-outline.nvim")
-- use("folke/trouble.nvim")
-- use("akinsho/toggleterm.nvim")
-- use("jayp0521/mason-null-ls.nvim")
-- use({
-- 	"rmagatti/goto-preview",
-- 	config = function()
-- 		require("goto-preview").setup({})
-- 	end,
-- })
