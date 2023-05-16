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

	use("christoomey/vim-tmux-navigator") -- Navigate between vim and tmux panes seamlessly
	use("lunarvim/horizon.nvim") -- Color scheme
	use({ "rose-pine/neovim", as = "rose-pine" })
	use("folke/tokyonight.nvim")
	use("rebelot/kanagawa.nvim")

	-- Replacing surroundings
	use("tpope/vim-surround")

	use("airblade/vim-rooter") -- Change directory to project root

	-- Commenting with gc
	use("numToStr/Comment.nvim")
	use("RRethy/vim-illuminate")

	-- CMP plugins
	use("hrsh7th/nvim-cmp") -- Autocompletion plugin
	use("hrsh7th/cmp-buffer") -- Autocompletion for buffers
	use("hrsh7th/cmp-path") -- Autocompletion for paths
	use("hrsh7th/cmp-cmdline") -- Autocompletion for cmdline
	use("saadparwaiz1/cmp_luasnip") -- Autocompletion for snippets
	use("onsails/lspkind-nvim") -- Autocompletion icons
	use("hrsh7th/cmp-nvim-lsp")
	use("hrsh7th/cmp-nvim-lua")

	-- snippets
	-- LuaSnip
	use("L3MON4D3/LuaSnip") -- Snippets plugin
	use("rafamadriz/friendly-snippets") -- Snippets collection

	-- LSP
	use("williamboman/mason.nvim")
	use("williamboman/mason-lspconfig.nvim")
	use("neovim/nvim-lspconfig")
	use("folke/neodev.nvim")
	use("jayp0521/mason-null-ls.nvim")
	use("jose-elias-alvarez/null-ls.nvim")
	use({ "glepnir/lspsaga.nvim", branch = "main" })
	use("jose-elias-alvarez/typescript.nvim")

	-- LSP support
	use("rust-lang/rust.vim")
	use("simrat39/rust-tools.nvim")
	use("mfussenegger/nvim-dap")
	use("saecki/crates.nvim")
	use("NvChad/nvim-colorizer.lua")
	use("roobert/tailwindcss-colorizer-cmp.nvim")

	-- Treesitter
	use("nvim-treesitter/nvim-treesitter", { run = ":TSUpdate" })
	use("JoosepAlviste/nvim-ts-context-commentstring")

	-- Telescope
	use("nvim-telescope/telescope.nvim")
	use({
		"nvim-telescope/telescope-fzf-native.nvim",
		run = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
	})
	use("nvim-telescope/telescope-media-files.nvim")
	use("nvim-telescope/telescope-project.nvim")


	use("windwp/nvim-ts-autotag")
	use("windwp/nvim-autopairs")

	use("lewis6991/gitsigns.nvim")

	use("folke/which-key.nvim")

	-- Nvim tree
	use("nvim-tree/nvim-tree.lua")
	use("nvim-tree/nvim-web-devicons")

	use("akinsho/bufferline.nvim")

	-- Status line
	use("nvim-lualine/lualine.nvim")
	use("akinsho/toggleterm.nvim")

	-- Copilot
	use("zbirenbaum/copilot.lua")
	use({
		"zbirenbaum/copilot-cmp",
		after = { "copilot.lua" },
		config = function()
			require("copilot_cmp").setup()
		end,
	})
  use( "folke/persistence.nvim" )

	-- Indentation line
	use("lukas-reineke/indent-blankline.nvim")
	use("echasnovski/mini.indentscope")

	use("ThePrimeagen/harpoon")
	use("goolord/alpha-nvim")
	use({
		"ahmedkhalf/project.nvim",
		config = function()
			require("project_nvim").setup({
				-- your configuration comes here
				-- or leave it empty to use the default settings
				-- refer to the configuration section below
			})
		end,
	})
	use("mbbill/undotree")

	-- Automatically set up your configuration after cloning packer.nvim
	-- Put this at the end after all plugins
	if packer_bootstrap then
		require("packer").sync()
	end
end)
