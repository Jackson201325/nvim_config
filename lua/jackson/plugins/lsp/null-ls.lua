local null_ls_status_ok, null_ls = pcall(require, "null-ls")
if not null_ls_status_ok then
	print("null_ls_status_ok not ok")
	return
end

local formatting = null_ls.builtins.formatting
local diagnostics = null_ls.builtins.diagnostics

null_ls.setup({
	debug = false,
	sources = {
		-- Js
		-- formatting.prettier.with({ extra_args = { "--no-semi", "--single-quote", "--jsx-single-quote" } }),
		formatting.prettier.with({ extra_args = {} }),
		-- diagnostics.eslint,

		-- TS
		-- require("typescript.extensions.null_ls.code_actions"),

		-- Ruby
		-- formatting.rubocop,
		-- diagnostics.reek,
		diagnostics.rubocop,
		formatting.rubyfmt,

		-- Lua
		formatting.stylua,

		-- Rust
		formatting.rustfmt,
	},
})
