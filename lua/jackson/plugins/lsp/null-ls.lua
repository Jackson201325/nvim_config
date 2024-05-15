local null_ls_status_ok, null_ls = pcall(require, "null-ls")
if not null_ls_status_ok then
  return
end

local formatting = null_ls.builtins.formatting
local diagnostics = null_ls.builtins.diagnostics

null_ls.setup({
  sources = {
    -- JS / TS
    formatting.prettier.with({ filetypes = { "svelte" } }),
    formatting.biome.with({ filetypes = { "javascript", "typescript", "javascriptreact", "typescriptreact", "json", "jsonc" } }),

    -- Ruby
    formatting.rubocop,

    -- Elixir
    formatting.mix,

    -- SQL
    -- formatting.sqlfmt,
    formatting.sql_formatter.with({ extra_args = { "-l", "postgresql" } }),

    -- Tailwind CSS
    formatting.rustywind,

    -- Python
    -- diagnostics.ruff,
    diagnostics.mypy,
    formatting.black,
  },
})
