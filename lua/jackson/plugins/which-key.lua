local status_ok, which_key = pcall(require, "which-key")
if not status_ok then
  return
end

local M = {}

function M.get_root()
  local path = vim.api.nvim_buf_get_name(0)
  path = path ~= "" and vim.loop.fs_realpath(path) or nil
  local roots = {}
  if path then
    for _, client in pairs(vim.lsp.get_active_clients({ bufnr = 0 })) do
      local workspace = client.config.workspace_folders
      local paths = workspace
          and vim.tbl_map(function(ws)
            return vim.uri_to_fname(ws.uri)
          end, workspace)
          or client.config.root_dir and { client.config.root_dir }
          or {}
      for _, p in ipairs(paths) do
        local r = vim.loop.fs_realpath(p)
        if path:find(r, 1, true) then
          roots[#roots + 1] = r
        end
      end
    end
  end
  table.sort(roots, function(a, b)
    return #a > #b
  end)
  local root = roots[1]
  if not root then
    path = path and vim.fs.dirname(path) or vim.loop.cwd()
    root = vim.fs.find(M.root_patterns, { path = path, upward = true })[1]
    root = root and vim.fs.dirname(root) or vim.loop.cwd()
  end
  return root
end

function M.telescope(builtin, opts)
  local params = { builtin = builtin, opts = opts }
  return function()
    builtin = params.builtin
    opts = params.opts
    opts = vim.tbl_deep_extend("force", { cwd = M.get_root() }, opts or {})
    if builtin == "files" then
      if vim.loop.fs_stat((opts.cwd or vim.loop.cwd()) .. "/.git") then
        opts.show_untracked = true
        builtin = "git_files"
      else
        builtin = "find_files"
      end
    end
    if opts.cwd and opts.cwd ~= vim.loop.cwd() then
      opts.attach_mappings = function(_, map)
        map("i", "<a-c>", function()
          local action_state = require("telescope.actions.state")
          local line = action_state.get_current_line()
          M.telescope(
            params.builtin,
            vim.tbl_deep_extend("force", {}, params.opts or {}, { cwd = false, default_text = line })
          )()
        end)
        return true
      end
    end
    require("telescope.builtin")[builtin](opts)
  end
end

-- Rest of your configuration starts here...
local setup = {
  plugins = {
    marks = true,       -- shows a list of your marks on ' and `
    registers = true,   -- shows your registers on " in NORMAL or <C-r> in INSERT mode
    spelling = {
      enabled = true,   -- enabling this will show WhichKey when pressing z= to select spelling suggestions
      suggestions = 20, -- how many suggestions should be shown in the list?
    },
    -- the presets plugin, adds help for a bunch of default keybindings in Neovim
    -- No actual key bindings are created
    presets = {
      operators = true,    -- adds help for operators like d, y, ... and registers them for motion / text object completion
      motions = true,      -- adds help for motions
      text_objects = true, -- help for text objects triggered after entering an operator
      windows = true,      -- default bindings on <c-w>
      nav = true,          -- misc bindings to work with windows
      z = true,            -- bindings for folds, spelling and others prefixed with z
      g = true,            -- bindings for prefixed with g
    },
  },
  -- add operators that will trigger motion and text object completion
  -- to enable all native operators, set the preset / operators plugin above
  -- operators = { gc = "Comments" },
  key_labels = {
    -- override the label used to display some keys. It doesn't effect WK in any other way.
    -- For example:
    -- ["<space>"] = "SPC",
    -- ["<cr>"] = "RET",
    -- ["<tab>"] = "TAB",
  },
  icons = {
    breadcrumb = "» ", -- symbol used in the command line area that shows your active key combo
    separator = "➜ ", -- symbol used between a key and it's label
    group = "+ ", -- symbol prepended to a group
  },

  popup_mappings = {
    scroll_down = "<c-d>", -- binding to scroll down inside the popup
    scroll_up = "<c-u>",   -- binding to scroll up inside the popup
  },
  window = {
    border = "none",          -- none, single, double, shadow
    position = "bottom",      -- bottom, top
    margin = { 1, 0, 1, 0 },  -- extra window margin [top, right, bottom, left]
    padding = { 2, 2, 2, 2 }, -- extra window padding [top, right, bottom, left]
    winblend = 0,
  },
  layout = {
    height = { min = 4, max = 25 },                                             -- min and max height of the columns
    width = { min = 20, max = 50 },                                             -- min and max width of the columns
    spacing = 3,                                                                -- spacing between columns
    align = "left",                                                             -- align columns left, center or right
  },
  ignore_missing = true,                                                        -- enable this to hide mappings for which you didn't specify a label
  hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ " }, -- hide mapping boilerplate
  show_help = true,                                                             -- show help message on the command line when the popup is visible
  triggers = "auto",                                                            -- automatically setup triggers
  -- triggers = {"<leader>"} -- or specify a list manually
  triggers_blacklist = {
    -- list of mode / prefixes that should never be hooked by WhichKey
    -- this is mostly relevant for key maps that start with a native binding
    -- most people should not need to change this
    i = { "j", "k" },
    v = { "j", "k" },
  },
}

local opts = {
  mode = "n",     -- NORMAL mode
  prefix = "<leader>",
  buffer = nil,   -- Global mappings. Specify a buffer number for buffer local mappings
  silent = true,  -- use `silent` when creating keymaps
  noremap = true, -- use `noremap` when creating keymaps
  nowait = true,  -- use `nowait` when creating keymaps
}

local mappings = {
  ["b"] = {
    "<cmd>lua require('telescope.builtin').buffers(require('telescope.themes').get_dropdown({ previewer = false }))<cr>",
    "Buffers",
  },
  ["c"] = { "<cmd>lua require('mini.bufremove').delete(0, false)<CR>", "Close Buffer" },
  ["C"] = { '<cmd>%bdelete|edit #|normal `"<CR>', "Close All Window except this one" },
  ["d"] = { "<cmd>Telescope diagnostics bufnr=0<cr>", "Buffer Diagnostics" },
  ["e"] = { "<cmd>Neotree toggle<cr>", "Explorer" },
  ["o"] = {
    "<cmd>lua require('telescope.builtin').lsp_document_symbols({ symbol_width = 60, previewer = false, initial_mode = normal, layout_config = { width = 0.3, height = 0.2 } })<CR>",
    "Open LSP outline",
  },
  ["O"] = {
    "<cmd>lua require('telescope.builtin').treesitter({ query = 'function', symbol_width = 60, previewer = false, initial_mode = normal, layout_config = { width = 0.2, height = 0.2 } })<CR>",
    "Open Symbols outline",
  },
  ["F"] = { "<cmd>lua require('telescope.builtin').find_files({no_ignore = true})<cr>", "Hidden" },
  ["j"] = { "<cmd>lua vim.api.nvim_win_set_height(0, vim.api.nvim_win_get_height(0) - 15)<CR>", "Decrease Height" },
  ["k"] = { "<cmd>lua vim.api.nvim_win_set_height(0, vim.api.nvim_win_get_height(0) + 15)<CR>", "Increase Height" },
  ["<"] = { "<cmd>lua vim.api.nvim_win_set_width(0, vim.api.nvim_win_get_width(0) - 15)<CR>", "Decrease Width" },
  [">"] = { "<cmd>lua vim.api.nvim_win_set_width(0, vim.api.nvim_win_get_width(0) + 15)<CR>", "Increase Width" },
  ["u"] = { "<cmd>UndotreeToggle<CR>", "Undo Tree" },
  ["x"] = { "<cmd>quit<CR>", "Close Split" },
  ["w"] = { "<cmd>lua vim.lsp.buf.format{async=true}<cr>", "Format" },
  ["<space>"] = { "<cmd>lua require('telescope.builtin').find_files()<cr>", "Find files" },
  ["/"] = { "<cmd> lua require('telescope').extensions.live_grep_args.live_grep_args({})<CR>", "Grep with Args" },
  ["="] = { "<C-w>=", "Split Equal" },
  ["-"] = { "<C-w>s", "Split window below" },
  ["\\"] = { "<C-w>v", "Split window right" },
  ["q"] = { "<cmd>copen<cr>", "Open Quickfix" },

  f = {
    name = "Find",
    c = { "<cmd>Telescope colorscheme<cr>", "Colorscheme" },
    d = {
      "<cmd>Telescope diagnostics bufnr=0<cr>",
      "Document Diagnostics",
    },
    g = { "<cmd>Easypick Changed Files<cr>", "Changed Files" },
    f = {
      "<cmd>lua require('telescope.builtin').find_files()<cr>",
      "Files",
    },
    F = { "<cmd>lua require('telescope.builtin').find_files({no_ignore = true})<cr>", "Hidden" },
    r = { M.telescope("oldfiles", { cwd = vim.loop.cwd() }), "Recent Files" },
    o = { "<cmd>Telescope git_status<cr>", "Open changed file" },
    w = {
      "<cmd>Telescope diagnostics<cr>",
      "Workspace Diagnostics",
    },
  },

  p = {
    name = "Packer",
    c = { "<cmd>PackerCompile<cr>", "Compile" },
    i = { "<cmd>PackerInstall<cr>", "Install" },
    s = { "<cmd>PackerSync<cr>", "Sync" },
    S = { "<cmd>PackerStatus<cr>", "Status" },
    u = { "<cmd>PackerUpdate<cr>", "Update" },
  },

  s = {
    name = "Search",
    a = { "<cmd>Telescope autocommands<cr>", "Auto Commands" },
    c = { "<cmd>Telescope commands<cr>", "Commands" },
    g = { "<cmd> lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>", "Grep with Args" },
    k = { "<cmd>Telescope keymaps<cr>", "Keymaps" },
    m = { "<cmd>Telescope marks<cr>", "Search Marks" },
    M = { "<cmd>Telescope man_pages<cr>", "Man Pages" },
    s = {
      M.telescope("lsp_document_symbols", {
        symbols = {
          "Class",
          "Function",
          "Method",
          "Constructor",
          "Interface",
          "Module",
          "Struct",
          "Trait",
          "Field",
          "Property",
        },
      }),
      "Document Symbols",
    },
    S = { M.telescope("lsp_workspace_symbols"), "Workspace Symbols", },
    w = { M.telescope("grep_string", { cwd = false }), "Word" },
  },

  g = {
    name = "Git",
    g = { "<cmd>lua LAZYGIT_TOGGLE()<CR>", "Lazygit" },
    d = { "<cmd>Gitsigns diffthis HEAD<cr>", "Diff" },
    o = { "<cmd>Telescope git_status<cr>", "Open changed file" },
  },

  l = {
    name = "LSP",
    a = { "<cmd>lua vim.lsp.buf.code_action()<cr>", "Code Action" },
    f = { "<cmd>lua vim.lsp.buf.format{async=true}<cr>", "Format" },
    l = { "<cmd>LspInfo<cr>", "Info" },
    L = { "<cmd>LspLog<cr>", "Lsp Log" },
    n = { "<cmd>NullLsInfo<cr>", "Null LS Info" },
    N = { "<cmd>NullLsLog<CR>", "Null LS Log" },
    q = { "<cmd>lua vim.diagnostic.setloclist()<cr>", "Quickfix" },
    r = { "<cmd>lua vim.lsp.buf.rename()<cr>", "Rename" },
  },

  r = {
    name = "Run",
    b = { "<cmd>lua DOCKER_BASH_TOGGLE()<cr>", "Docker Bash" },
    d = { "<cmd>lua DOCKER_UP_TOGGLE()<cr>", "Docker up" },
    f = { "<cmd>lua RAILS_FOREMAN_TOGGLE()<cr>", "Foreman" },
    n = { "<cmd>lua NPM_SERVER_TOGGLE()<cr>", "NPM server" },
    r = {
      name = "Rails",
      b = { "<cmd>lua BYEBUG_SERVER_TOGGLE()<cr>", "Byebug server" },
      r = { "<cmd>lua RAILS_ROUTES_TOGGLE()<cr>", "Rails Routes" },
      c = { "<cmd>lua RAILS_CONSOLE_TOGGLE()<cr>", "Rails Console" },
    },
    s = { "<cmd>lua RAILS_SERVER_TOGGLE()<cr>", "Rails Server" },
    y = { "<cmd>lua YARN_SERVER_TOGGLE()<cr>", "Yarn Start" },
  },

  T = { "<cmd>terminal<cr>", "New Terminal" },

  n = {
    name = "Noice",
    d = { "<cmd>NoiceDismiss<cr>", "Dismiss" },
    h = { "<cmd>NoiceHistory<cr>", "History" },
  },

  t = {
    name = "Terminal",
    t = { ":vsplit term://zsh<CR>", "New Split Terminal" },
    f = { "<cmd>ToggleTerm direction=float<cr>", "Float" },
    h = { "<cmd>ToggleTerm size=18 direction=horizontal<cr>", "Horizontal" },
    v = { "<cmd>ToggleTerm size=220 direction=vertical<cr>", "Vertical" },
  },
}

which_key.setup(setup)
which_key.register(mappings, opts)
