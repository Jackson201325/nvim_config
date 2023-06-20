local M = {}

local status_cmp_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not status_cmp_ok then
	return
end

local status_ok, which_key = pcall(require, "which-key")
if not status_ok then
	return
end

M.capabilities = vim.lsp.protocol.make_client_capabilities()
M.capabilities.textDocument.completion.completionItem.snippetSupport = true
M.capabilities = cmp_nvim_lsp.default_capabilities(M.capabilities)

M.setup = function()
	local signs = {
		{ name = "DiagnosticSignError", text = "" },
		{ name = "DiagnosticSignWarn", text = "" },
		{ name = "DiagnosticSignHint", text = "" },
		{ name = "DiagnosticSignInfo", text = "" },
	}

	for _, sign in ipairs(signs) do
		vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
	end

	local config = {
		virtual_text = false, -- disable virtual text
		signs = {
			active = signs, -- show signs
		},
		update_in_insert = true,
		underline = true,
		severity_sort = true,
		float = {
			focusable = true,
			style = "minimal",
			border = "rounded",
			source = "always",
			header = "",
			prefix = "",
		},
	}

	vim.diagnostic.config(config)

	vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
		border = "rounded",
	})

	vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
		border = "rounded",
	})
end

M.on_attach = function(client, bufnr)
	local istatus_ok, illuminate = pcall(require, "illuminate")
	if not istatus_ok then
		return
	end

	if client.name == "solargraph" then
		client.server_capabilities.documentFormattingProvider = false
	end

	illuminate.on_attach(client)

	local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

	if client.supports_method("textDocument/formatting") then
		vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
		vim.api.nvim_create_autocmd("BufWritePre", {
			group = augroup,
			buffer = bufnr,
			callback = function()
				vim.lsp.buf.format()
			end,
		})
	end
end

local mappings = {
	g = {
		name = "Actions",
		a = { "<cmd>Lspsaga code_action<CR>", "Code Action" },
		H = { "<cmd>Gitsigns prev_hunk<CR>", "Go to previous hunk" },
		h = { "<cmd>Gitsigns next_hunk<CR>", "Go to next hunk" },
		l = { "<cmd>Lspsaga show_line_diagnostics<CR>", "Show Line Diagnostics" },
		c = { "<cmd>Lspsaga show_cursor_diagnostics<CR>", "Show Cursor Diagnostics" },
		d = { "<cmd>Lspsaga goto_definition zz<CR>", "Goto Definition" },
		D = { ":vsplit | Lspsaga goto_definition<CR>", "Goto Definition in Split" },
		r = { "<cmd>Lspsaga lsp_finder<CR>", "LSP Finder" },
		p = { "<cmd>Lspsaga peek_definition<CR>", "Peek Definition" },
		R = { "<cmd>Telescope lsp_references<CR>", "References" },
	},
	t = {
		name = "TypeScript Actions",
		a = { "<cmd>TypescriptAddMissingImports<CR>", "Add Missing Imports" },
		r = { "<cmd>TypescriptRenameFile<CR>", "Rename File" },
		f = { "<cmd>TypescriptFixAll<CR>", "Fix All" },
		d = { "<cmd>TypescriptGoToSourceDefinition<CR>", "Go to Definition" },
		o = { "<cmd>TypescriptOrganizeImports<CR>", "Organize Imports" },
		u = { "<cmd>TypescriptRemoveUnsed<CR>", "Remove Unused" },
	},
	K = { "<cmd>Lspsaga hover_doc<CR>", "Hover Doc" },
}

local opts = {
	mode = "n", -- NORMAL mode
	buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
	silent = true, -- use `silent` when creating keymaps
	noremap = true, -- use `noremap` when creating keymaps
	nowait = true, -- use `nowait` when creating keymaps
}

which_key.register(mappings, opts)

return M

-- if client.name == "tsserver" then
-- 	vim.keymap.set(
-- 		"n",
-- 		"ta",
-- 		"<cmd>TypescriptAddMissingImports<CR>",
-- 		{ buffer = bufnr, desc = "Add missing imports" }
-- 	)
-- 	vim.keymap.set("n", "tr", "<cmd>TypescriptRenameFile<CR>", { desc = "Rename File", buffer = bufnr })
-- 	vim.keymap.set("n", "tf", "<cmd>TypescriptFixAll<CR>", { desc = "Fix File", buffer = bufnr })
-- 	vim.keymap.set("n", "td", "<cmd>TypescriptGoToSourceDefinition<CR>", { desc = "Go to Definition" })
-- 	vim.keymap.set("n", "to", "<cmd>TypescriptOrganizeImports<CR>", { desc = "Rename File", buffer = bufnr })
-- 	vim.keymap.set("n", "tu", "<cmd>TypescriptRemoveUnsed<CR>", { desc = "Rename File", buffer = bufnr })
-- end
