local lspconfig = require("lspconfig")

return {
	rust_analyzer = {
		root_dir = lspconfig.util.root_pattern(".git", "Cargo.toml"),
		filetypes = {
			"rust",
		},
		settings = {
			["rust-analyzer"] = {
				cargo = {
					allfeatures = true,
					loadOutDirsFromCheck = true,
				},
				procMacro = {
					enable = true,
				},
			},
		},
	},
	-- {
	-- 	"rust-lang/rust.vim",
	-- 	ft = {
	-- 		"rust",
	-- 	},
	-- 	init = function()
	-- 		vim.g.rustfmt_autosave = 1
	-- 	end,
	-- },
	-- {
	-- 	"simrat39/rust-tools.nvim",
	-- 	ft = "rust",
	-- 	dependencies = {
	-- 		"neovim/nvim-lspconfig",
	-- 	},
	-- 	config = function()
	-- 		require("rust-tools").setup({})
	-- 	end,
	-- },
	-- {
	-- 	"mfussenegger/nvim-dap",
	-- },
	-- {
	-- 	"saecki/crates.nvim",
	-- 	ft = {
	-- 		"rust",
	-- 		"toml",
	-- 	},
	-- 	config = function(_, opts)
	-- 		local crates = require("crates")
	-- 		crates.setup(opts)
	-- 		crates.show()
	-- 	end,
	-- },
	-- {
	-- 	"hrsh7th/nvim-cmp",
	-- 	opt = function()
	-- 		local cmp = require("cmp")
	-- 		table.insert(cmp.sources, { name = "crates" })
	-- 		return cmp
	-- 	end,
	-- },
}
