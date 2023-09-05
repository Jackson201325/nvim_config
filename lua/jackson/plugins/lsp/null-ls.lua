local null_ls_status_ok, null_ls = pcall(require, "null-ls")
if not null_ls_status_ok then
  return
end

local formatting = null_ls.builtins.formatting
local diagnostics = null_ls.builtins.diagnostics
-- local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

null_ls.setup({
  debug = false,
  -- on_attach = function(client, bufnr)
  --   if client.supports_method("textDocument/formatting") then
  --     vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
  --     vim.api.nvim_create_autocmd("BufWritePre", {
  --       group = augroup,
  --       buffer = bufnr,
  --       callback = function()
  --         -- vim.lsp.buf.format()
  --       end,
  --     })
  --   end
  -- end,
  sources = {
    -- Js
    -- formatting.prettier.with({ extra_args = { "--no-semi", "--single-quote" } }),
    -- formatting.prettier_eslint.with({ extra_args = { "--single-quote" } }),
    -- formatting.prettier.with({ extra_args = { "--no-semi", "--double-quote" } }),
    diagnostics.eslint,
    diagnostics.tsc,
    formatting.prettier,

    -- Ruby
    formatting.rubocop.with({ timeout = 10000 }),
    -- diagnostics.rubocop.with({
    --   method = null_ls.methods.DIAGNOSTICS_ON_SAVE,
    -- }),
    -- diagnostics.reek,
    -- formatting.rubyfmt,

    -- Prisma
    formatting.prismaFmt,

    -- Eruby
    -- formatting.erb_lint,
    -- diagnostics.erb_lint,

    -- Lua
    formatting.stylua,

    -- Rust
    -- formatting.rustfmt,

    -- GO
    -- formatting.gofumpt,
    -- formatting.goimports_reviser,
    -- formatting.golines,
  },
})
