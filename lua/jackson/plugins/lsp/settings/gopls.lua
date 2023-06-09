local lspconfig = require("lspconfig")

return {
	gopls = {
		root_dir = lspconfig.util.root_pattern("go.work", "go.mod", ".git"),
		filetypes = { "go", "gomod", "gowork", "gotmpl" },
		cmd = { "gopls" },
		settings = {
			gopls = {
        completeUnimported = true,
        usePlaceholders = true,
        analyses = {
          unusedparams = true,
          unreachable = true,
        },
      },
		},
	},
}
