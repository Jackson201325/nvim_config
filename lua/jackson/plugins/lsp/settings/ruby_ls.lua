local lspconfig = require("lspconfig")

return {
	ruby_ls = {
		root_dir = lspconfig.util.root_pattern(".git", "Gemfile"),
		filetypes = {
			"ruby",
		},
		settings = {},
	},
}
