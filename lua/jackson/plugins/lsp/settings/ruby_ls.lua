local util = require("lspconfig.util")

return {
	cmd = { "ruby-lsp" },
	filetypes = { "ruby" },
	root_dir = util.root_pattern("Gemfile", ".git"),
	init_options = {
		-- formatter = "auto",
	},
	single_file_support = true,
}
