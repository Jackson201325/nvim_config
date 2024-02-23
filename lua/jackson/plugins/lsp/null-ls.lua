local null_ls_status_ok, null_ls = pcall(require, "null-ls")
if not null_ls_status_ok then
  return
end

local formatting = null_ls.builtins.formatting
local diagnostics = null_ls.builtins.diagnostics

null_ls.setup({
  sources = {
    -- JS / TS
    formatting.prettier,

    -- Ruby
    formatting.rubocop,

    -- Elixir
    formatting.mix,

    -- SQL
    formatting.sqlfmt,

    -- Python
    diagnostics.ruff,
    diagnostics.mypy,
    formatting.black,
  },
})
