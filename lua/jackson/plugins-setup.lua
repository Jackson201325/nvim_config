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
	use("lunarvim/horizon.nvim")
	use({ "rose-pine/neovim", as = "rose-pine" })
	use("folke/tokyonight.nvim")
	use("rebelot/kanagawa.nvim")
	use("bluz71/vim-nightfly-colors")

	-- Replacing surroundings
	use("tpope/vim-surround")

	-- Change directory to project root
	use("airblade/vim-rooter")

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
	use("jayp0521/mason-null-ls.nvim")
	use("jose-elias-alvarez/null-ls.nvim")
	use("folke/neodev.nvim")

	-- LSP support
	use({ "glepnir/lspsaga.nvim", branch = "main" })
	use("jose-elias-alvarez/typescript.nvim")
	use("rust-lang/rust.vim")
	use("simrat39/rust-tools.nvim")
	use("mfussenegger/nvim-dap")
	use("saecki/crates.nvim")
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

	-- Coding
	use("windwp/nvim-ts-autotag")
	use("windwp/nvim-autopairs")
	use("numToStr/Comment.nvim")
	use({
		"ahmedkhalf/project.nvim",
		config = function()
			require("project_nvim").setup({})
		end,
	})

	-- UI
	use("lewis6991/gitsigns.nvim")
	use("goolord/alpha-nvim")
	use("NvChad/nvim-colorizer.lua")
	use("folke/which-key.nvim")
	use("RRethy/vim-illuminate")

	-- Outliner
	use("simrat39/symbols-outline.nvim")

	-- Movement
	use("mbbill/undotree")
	use("ThePrimeagen/harpoon")
	use("christoomey/vim-tmux-navigator") -- Navigate between vim and tmux panes seamlessly

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

	-- Bufferline
	use("akinsho/bufferline.nvim")

	-- Status line
	use("nvim-lualine/lualine.nvim")

	--Terminal
	use("akinsho/toggleterm.nvim")

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
