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
  g = {
    name = "Actions",
    -- a = { "<cmd>lua vim.lsp.buf.code_action()<cr>", "Code Action" },
    a = { ":Lspsaga code_action<cr>", "Code Action" },
    c = { "<cmd>lua vim.diagnostic.open_float()<cr>", "Show Cursor Diagnostics" },
    -- goto_definition
    d = { "<Cmd>lua vim.lsp.buf.definition()<CR>", "Go to Definition" },
    D = { ":vsplit | lua vim.lsp.buf.definition()<cr>", "Go to Definition in Split" },
    h = { "<cmd>Gitsigns next_hunk<CR>", "Go to next hunk" },
    H = { "<cmd>Gitsigns prev_hunk<CR>", "Go to previous hunk" },
    i = { "<cmd>lua vim.lsp.buf.implementation()<cr>", "Go to implementation" },
    -- l = { "<cmd>lua vim.diagnostic.open_float()<cr>", "Show Line Diagnostics" },
    l = { ":Lspsaga diagnostic_jump_next<CR>", "Show Line Diagnostics next" },
    L = { ":Lspsaga diagnostic_jump_prev<CR>", "Show Line Diagnostics previous" },
    R = { "<cmd>lua vim.lsp.buf.references()<CR>", "LSP Finder" },
    r = { "<cmd>Telescope lsp_references<CR>", "References" },
    t = { "<cmd>lua vim.lsp.buf.type_definition()<cr>", "Go to Type definition" },
    p = { "<cmd>Lspsaga peek_definition<CR>", "Peek Definition" },
  },

  t = {
    name = "TypeScript Actions",
    a = { "<cmd>TSToolsAddMissingImports<CR>", "Add Missing Imports" },
    r = { "<cmd>TSToolsFileReferences<CR>", "Find references" },
    R = { "<cmd>TSToolsRenameFile<CR>", "Rename File" },
    f = { "<cmd>TSToolsFixAll<CR>", "Fix All" },
    d = { "<cmd>TSToolsGoToSourceDefinition<CR>", "Go to Definition" },
    o = { "<cmd>TSToolsOrganizeImports<CR>", "Organize Imports" },
    u = { "<cmd>TSToolsRemoveUnusedImports<CR>", "Remove Unused Import" },
    U = { "<cmd>TSToolsRemoveUnused<CR>", "Remove Unused Statement" },
  },
  K = { "<cmd>lua vim.lsp.buf.hover()<cr>", "Hover Doc" },
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
