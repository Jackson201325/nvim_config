local M = {}

local status_cmp_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not status_cmp_ok then
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
		virtual_text = true, -- disable virtual text
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

local function lsp_keymaps(bufnr)
	local opts = { noremap = true, silent = true }
	local keymap = vim.api.nvim_buf_set_keymap
	keymap(bufnr, "n", "gf", "<cmd>Lspsaga lsp_finder<CR>", opts)
	keymap(bufnr, "n", "gdd", ":vsplit | Lspsaga goto_definition<CR>", opts)
	keymap(bufnr, "n", "gd", "<cmd>Lspsaga goto_definition<CR>", opts)
	keymap(bufnr, "n", "gh", "<cmd>Lspsaga code_action<CR>", opts)
	keymap(bufnr, "n", "K", "<cmd>Lspsaga hover_doc<CR>", opts)
	keymap("<cmd>Telescope lsp_references<CR>", "n", "gr", bufnr, { desc = "References" })
	keymap(bufnr, "n", "gp", "<cmd>Lspsaga peek_definition<CR>", opts)
end

M.on_attach = function(client, bufnr)
	if client.name == "tsserver" then
		client.server_capabilities.documentFormattingProvider = false
		vim.keymap.set(
			"n",
			"<leader>co",
			"<cmd>TypescriptOrganizeImports<CR>",
			{ buffer = bufnr, desc = "Organize Imports" }
		)
		vim.keymap.set("n", "<leader>cR", "<cmd>TypescriptRenameFile<CR>", { desc = "Rename File", buffer = bufnr })
	end

	if client.name == "solargraph" then
		client.server_capabilities.documentFormattingProvider = false
	end

	lsp_keymaps(bufnr)


	local status_ok, illuminate = pcall(require, "illuminate")
	if not status_ok then
		return
	end

	illuminate.on_attach(client)

	local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

	if client.supports_method("textDocument/formatting") then
    print("hello this is client")
    print(client)
		vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
		vim.api.nvim_create_autocmd("BufWritePre", {
			group = augroup,
			buffer = bufnr,
			callback = function()
				vim.lsp.buf.format()
			end,
		})
	end

	-- Autoformat
	-- vim.cmd([[autocmd BufWritePre <buffer> lua vim.lsp.buf.format({ async = true})]])
end

return M
