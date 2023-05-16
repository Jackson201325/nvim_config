local null_ls_status_ok, null_ls = pcall(require, "null-ls")
if not null_ls_status_ok then
	print("null_ls_status_ok not ok")
	return
end

-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
local formatting = null_ls.builtins.formatting
-- local diagnostics = null_ls.builtins.diagnostics
-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
local diagnostics = null_ls.builtins.diagnostics

null_ls.setup({
	debug = false,
	sources = {
		-- Js
		formatting.prettier.with({ extra_args = { "--no-semi", "--single-quote", "--jsx-single-quote" } }),
		diagnostics.eslint,

		-- Ruby
		formatting.rubocop,
		diagnostics.rubocop,

		formatting.black.with({ extra_args = { "--fast" } }),

    -- Lua

		formatting.stylua,
		-- diagnostics.flake8
	},
})
