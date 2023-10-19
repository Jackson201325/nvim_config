return {
	tsserver = {
		keys = {
			{
				"tf",
				function()
					vim.lsp.buf.code_action({
						apply = true,
						context = {
							only = { "source.fixAll.ts" },
							diagnostics = {},
						},
					})
				end,
				desc = "Fix All",
			},
			{
				"tu",
				function()
					vim.lsp.buf.code_action({
						apply = true,
						context = {
							only = { "source.removeUnused.ts" },
							diagnostics = {},
						},
					})
				end,
				desc = "Remove Unsused Variables",
			},
			{
				"ta",
				function()
					vim.lsp.buf.code_action({
						apply = true,
						context = {
							only = { "source.addMissingImports.ts" },
							diagnostics = {},
						},
					})
				end,
				desc = "Add Imports",
			},
			{
				"to",
				function()
					vim.lsp.buf.code_action({
						apply = true,
						context = {
							only = { "source.organizeImports.ts" },
							diagnostics = {},
						},
					})
				end,
				desc = "Organize Imports",
			},
		},
		settings = {
			typescript = {
				-- format = {
				-- 	indentSize = vim.o.shiftwidth,
				-- 	convertTabsToSpaces = vim.o.expandtab,
				-- 	tabSize = vim.o.tabstop,
				-- },
			},
			javascript = {
				-- format = {
				-- 	indentSize = vim.o.shiftwidth,
				-- 	convertTabsToSpaces = vim.o.expandtab,
				-- 	tabSize = vim.o.tabstop,
				-- },
			},
			completions = {
				completeFunctionCalls = true,
			},
		},
	},
}
