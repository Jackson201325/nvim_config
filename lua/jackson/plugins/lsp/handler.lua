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
    { name = "DiagnosticSignWarn",  text = "" },
    { name = "DiagnosticSignHint",  text = "" },
    { name = "DiagnosticSignInfo",  text = "" },
  }

  for _, sign in ipairs(signs) do
    vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
  end

  local config = {
    virtual_text = false, -- disable virtual text
    signs = {
      active = signs,     -- show signs
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
  illuminate.on_attach(client)

  if client.name == "solargraph" then
    client.server_capabilities.documentFormattingProvider = false
  end

  require("lsp-format").on_attach(client)
end

local mappings = {
  g = {
    name = "Actions",
    a = { "<cmd>Lspsaga code_action<CR>", "Code Action" },
    c = { "<cmd>Lspsaga show_cursor_diagnostics<CR>", "Show Cursor Diagnostics" },
    d = { "<cmd>Lspsaga goto_definition zz<CR>", "Goto Definition" },
    D = { ":vsplit | Lspsaga goto_definition zz<CR>", "Goto Definition in Split" },
    h = { "<cmd>Gitsigns next_hunk<CR>", "Go to next hunk" },
    H = { "<cmd>Gitsigns prev_hunk<CR>", "Go to previous hunk" },
    l = { "<cmd>Lspsaga show_line_diagnostics<CR>", "Show Line Diagnostics" },
    p = { "<cmd>Lspsaga peek_definition<CR>", "Peek Definition" },
    r = { "<cmd>Lspsaga finder<CR>", "LSP Finder" },
    R = { "<cmd>Telescope lsp_references<CR>", "References" },
  },
  t = {
    name = "TypeScript Actions",
    a = { "<cmd>TypescriptAddMissingImports<CR>", "Add Missing Imports" },
    r = { "<cmd>TypescriptRenameFile<CR>", "Rename File" },
    f = { "<cmd>TypescriptFixAll<CR>", "Fix All" },
    d = { "<cmd>TypescriptGoToSourceDefinition<CR>", "Go to Definition" },
    o = { "<cmd>TypescriptOrganizeImports<CR>", "Organize Imports" },
    u = { "<cmd>TypescriptRemoveUnused<CR>", "Remove Unused" },
  },
  K = { "<cmd>Lspsaga hover_doc<CR>", "Hover Doc" },
}

local opts = {
  mode = "n",     -- NORMAL mode
  buffer = nil,   -- Global mappings. Specify a buffer number for buffer local mappings
  silent = true,  -- use `silent` when creating keymaps
  noremap = true, -- use `noremap` when creating keymaps
  nowait = true,  -- use `nowait` when creating keymaps
}

which_key.register(mappings, opts)

return M
