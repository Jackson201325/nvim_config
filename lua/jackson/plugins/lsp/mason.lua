local servers = {
  "biome",
  "dockerls",
  "elixirls",
  "graphql",
  "jsonls",
  "lua_ls",
  "prismals",
  "pyright",
  "solargraph",
  "sqlls",
  "tailwindcss",
  "volar",
  "svelte"
  -- "ember",
  -- "eslint",
  -- "ruby_ls",
  -- "tsserver",
}

-- IMPORTANT: make sure to setup neodev BEFORE lspconfig
require("neodev").setup({})

local settings = {
  ui = {
    border = "none",
    icons = {
      package_installed = "◍",
      package_pending = "◍",
      package_uninstalled = "◍",
    },
  },
  log_level = vim.log.levels.INFO,
  max_concurrent_installers = 4,
}

require("mason").setup(settings)
require("mason-lspconfig").setup({
  ensure_installed = servers,
  automatic_installation = true,
})

local lspconfig_status_ok, lspconfig = pcall(require, "lspconfig")
if not lspconfig_status_ok then
  return
end

local opts = {}

for _, server in pairs(servers) do
  opts = {
    on_attach = require("jackson.plugins.lsp.handler").on_attach,
    capabilities = require("jackson.plugins.lsp.handler").capabilities,
  }

  server = vim.split(server, "@")[1]

  local require_ok, conf_opts = pcall(require, "jackson.plugin.lsp.settings." .. server)
  if require_ok then
    opts = vim.tbl_deep_extend("force", conf_opts, opts)
  end

  lspconfig[server].setup(opts)
end
