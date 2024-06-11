local null_ls_status_ok, null_ls = pcall(require, "null-ls")
if not null_ls_status_ok then
  return
end

local formatting = null_ls.builtins.formatting
local diagnostics = null_ls.builtins.diagnostics

-- Pattern to match project and any of its subdirectories
local specific_project_pattern = "Code/project"

-- Function to check if cwd matches the project pattern
local function is_specific_project(cwd, pattern)
  return cwd:match(pattern)
end

-- Base configuration for null-ls
local sources = {
  -- Ruby
  formatting.rubocop,

  -- Elixir
  formatting.mix,

  -- SQL
  formatting.sql_formatter.with({ extra_args = { "-l", "postgresql" } }),

  -- Tailwind CSS
  formatting.rustywind,

  -- Python
  diagnostics.mypy,
  formatting.black,
}

-- Determine the JavaScript formatter based on the current working directory
local cwd = vim.fn.getcwd()
if is_specific_project(cwd, specific_project_pattern) then
  print("Using biome for JavaScript")
  table.insert(sources, formatting.biome.with({ filetypes = { "javascript", "typescript", "javascriptreact", "typescriptreact" } }))
else
  table.insert(sources, formatting.prettier)
end

null_ls.setup({
  debug = true,
  sources = sources,
})
