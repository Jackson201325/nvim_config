local status_ok, lspconfig = pcall(require("lspconfig"))
if not status_ok then
	return
end

lspconfig.tsserver.setup({
	settings = {
		typescript = {
			format = {
				indentSize = vim.o.shiftwidth,
				convertTabsToSpaces = vim.o.expandtab,
				tabSize = vim.o.tabstop,
			},
		},
		javascript = {
			format = {
				indentSize = vim.o.shiftwidth,
				convertTabsToSpaces = vim.o.expandtab,
				tabSize = vim.o.tabstop,
			},
		},
		completions = {
			completeFunctionCalls = true,
		},
	},
})
