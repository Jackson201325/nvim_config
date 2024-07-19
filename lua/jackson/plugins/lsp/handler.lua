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
    { name = "DiagnosticSignWarn", text = "" },
    { name = "DiagnosticSignHint", text = "󰌵" },
    { name = "DiagnosticSignInfo", text = "" },
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

  vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
    -- underline = true,
    -- virtual_text = {
    -- 	spacing = 5,
    -- 	severity_limit = "Warning",
    -- },
    border = "rounded",
    underline = true,
    -- update_in_insert = true,
  })

  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = "rounded",
  })

  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
    border = "rounded",
  })
end

M.on_attach = function(client, bufnr)
  if
      client.name == "solargraph"
      or client.name == "tsserver"
      or client.name == "ruby_ls"
      or client.name == "primsls"
      or client.name == "biome"
  then
    client.server_capabilities.documentFormattingProvider = false
  end

  if client.name == "eslint" then
    vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = bufnr,
      command = "EslintFixAll",
    })
  end

  local istatus_ok, illuminate = pcall(require, "illuminate")
  if istatus_ok then
    illuminate.on_attach(client)
  end
end

local mappings = {
  { "K",  "<cmd>lua vim.lsp.buf.hover()<cr>",           desc = "Hover Doc",                      nowait = true, remap = false },
  { "g",  group = "Actions", },
  { "gD", ":vsplit | lua vim.lsp.buf.definition()<cr>", desc = "Go to Definition in Split",      nowait = true, remap = false },
  { "gH", "<cmd>Gitsigns prev_hunk<CR>",                desc = "Go to previous hunk",            nowait = true, remap = false },
  { "gL", ":Lspsaga diagnostic_jump_prev<CR>",          desc = "Show Line Diagnostics previous", nowait = true, remap = false },
  { "gR", "<cmd>lua vim.lsp.buf.references()<CR>",      desc = "LSP Finder",                     nowait = true, remap = false },
  { "ga", ":Lspsaga code_action<cr>",                   desc = "Code Action",                    nowait = true, remap = false },
  { "gc", "<cmd>lua vim.diagnostic.open_float()<cr>",   desc = "Show Cursor Diagnostics",        nowait = true, remap = false },
  { "gd", "<Cmd>lua vim.lsp.buf.definition()<CR>",      desc = "Go to Definition",               nowait = true, remap = false },
  { "gh", "<cmd>Gitsigns next_hunk<CR>",                desc = "Go to next hunk",                nowait = true, remap = false },
  { "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>",  desc = "Go to implementation",           nowait = true, remap = false },
  { "gl", ":Lspsaga diagnostic_jump_next<CR>",          desc = "Show Line Diagnostics next",     nowait = true, remap = false },
  { "gp", "<cmd>Lspsaga peek_definition<CR>",           desc = "Peek Definition",                nowait = true, remap = false },
  { "gr", "<cmd>Telescope lsp_references<CR>",          desc = "References",                     nowait = true, remap = false },
  { "gt", "<cmd>lua vim.lsp.buf.type_definition()<cr>", desc = "Go to Type definition",          nowait = true, remap = false },
  { "t",  group = "TypeScript Actions",                 nowait = true,                           remap = false },
  { "tR", "<cmd>TSToolsRenameFile<CR>",                 desc = "Rename File",                    nowait = true, remap = false },
  { "tU", "<cmd>TSToolsRemoveUnused<CR>",               desc = "Remove Unused Statement",        nowait = true, remap = false },
  { "ta", "<cmd>TSToolsAddMissingImports<CR>",          desc = "Add Missing Imports",            nowait = true, remap = false },
  { "td", "<cmd>TSToolsGoToSourceDefinition<CR>",       desc = "Go to Definition",               nowait = true, remap = false },
  { "tf", "<cmd>TSToolsFixAll<CR>",                     desc = "Fix All",                        nowait = true, remap = false },
  { "to", "<cmd>TSToolsOrganizeImports<CR>",            desc = "Organize Imports",               nowait = true, remap = false },
  { "tr", "<cmd>TSToolsFileReferences<CR>",             desc = "Find references",                nowait = true, remap = false },
  { "tu", "<cmd>TSToolsRemoveUnusedImports<CR>",        desc = "Remove Unused Import",           nowait = true, remap = false },
}

local opts = {
  mode = "n",     -- NORMAL mode
  buffer = nil,   -- Global mappings. Specify a buffer number for buffer local mappings
  silent = true,  -- use `silent` when creating keymaps
  noremap = true, -- use `noremap` when creating keymaps
  nowait = true,  -- use `nowait` when creating keymaps
}

which_key.add(mappings, opts)

return M
