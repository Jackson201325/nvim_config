local null_ls_status_ok, null_ls = pcall(require, "null-ls")
if not null_ls_status_ok then
	return
end

local formatting = null_ls.builtins.formatting
local diagnostics = null_ls.builtins.diagnostics

null_ls.setup({
	sources = {
		-- Js TS
		-- formatting.prettier.with({ extra_args = { "--no-semi", "--single-quote" } }),
		-- formatting.prettier_eslint.with({ extra_args = { "--single-quote" } }),
		-- formatting.prettier.with({ extra_args = { "--no-semi", "--double-quote" } }),
		-- diagnostics.eslint,
		-- diagnostics.tsc,
		formatting.prettier,
		-- formatting.prettierd,
		-- formatting.prettier_eslint,

		-- Ruby
		-- formatting.rubocop.with({ timeout = 10000 }),
		formatting.rubocop,
		-- diagnostics.rubocop,
		-- diagnostics.rubocop.with({
		--   method = null_ls.methods.DIAGNOSTICS_ON_SAVE,
		-- }),
		-- diagnostics.reek,
		-- formatting.rubyfmt,

		-- Eruby
		-- formatting.erb_lint,
		-- diagnostics.erb_lint,

		-- Lua
		formatting.stylua,

		-- Elixir
		formatting.mix,

		-- SQL
		-- formatting.sql_formatter.with({
		--   extra_args = { "tabWidth", "2", "keywordCase", "upper" },
		-- }),
		-- formatting.pg_format.with({
		-- 	filetypes = { "sql" },
		-- }),
		formatting.sqlfmt,
		-- formatting.sql_formatter,
		-- formatting.sqlformat,
		-- diagnostics.sqlfluff.with({
		-- 	extra_args = { "--dialect", "postgres" },
		-- }),

		-- Python
		diagnostics.ruff,
		diagnostics.mypy,
		formatting.black,
	},
})
