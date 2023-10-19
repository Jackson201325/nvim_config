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
}
