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
  ---@type false | "classic" | "modern" | "helix"
  preset = "classic",
  -- Delay before showing the popup. Can be a number or a function that returns a number.
  ---@type number | fun(ctx: { keys: string, mode: string, plugin?: string }):number
  delay = function(ctx)
    return ctx.plugin and 0 or 200
  end,
  ---@param mapping wk.Mapping
  filter = function(mapping)
    -- example to exclude mappings without a description
    -- return mapping.desc and mapping.desc ~= ""
    return true
  end,
  --- You can add any mappings here, or use `require('which-key').add()` later
  ---@type wk.Spec
  spec = {},
  -- show a warning when issues were detected with your mappings
  notify = true,
  -- Which-key automatically sets up triggers for your mappings.
  -- But you can disable this and setup the triggers manually.
  -- Check the docs for more info.
  ---@type wk.Spec
  triggers = {
    { "<auto>", mode = "nixsotc" },
  },
  -- Start hidden and wait for a key to be pressed before showing the popup
  -- Only used by enabled xo mapping modes.
  ---@param ctx { mode: string, operator: string }
  defer = function(ctx)
    return ctx.mode == "V" or ctx.mode == "<C-V>"
  end,
  plugins = {
    marks = true,     -- shows a list of your marks on ' and `
    registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
    -- the presets plugin, adds help for a bunch of default keybindings in Neovim
    -- No actual key bindings are created
    spelling = {
      enabled = true,   -- enabling this will show WhichKey when pressing z= to select spelling suggestions
      suggestions = 20, -- how many suggestions should be shown in the list?
    },
    presets = {
      operators = true,    -- adds help for operators like d, y, ...
      motions = true,      -- adds help for motions
      text_objects = true, -- help for text objects triggered after entering an operator
      windows = true,      -- default bindings on <c-w>
      nav = true,          -- misc bindings to work with windows
      z = true,            -- bindings for folds, spelling and others prefixed with z
      g = true,            -- bindings for prefixed with g
    },
  },
  ---@type wk.Win.opts
  win = {
    -- don't allow the popup to overlap with the cursor
    no_overlap = true,
    -- width = 1,
    -- height = { min = 4, max = 25 },
    -- col = 0,
    -- row = math.huge,
    border = "none",
    padding = { 2, 2, 2, 2 }, -- extra window padding [top, right, bottom, left]
    title = true,
    title_pos = "center",
    zindex = 1000,
    -- Additional vim.wo and vim.bo options
    bo = {},
    wo = {
      -- winblend = 10, -- value between 0-100 0 for fully opaque and 100 for fully transparent
    },
  },
  layout = {
    height = { min = 4, max = 25 }, -- min and max height of the columns
    width = { min = 20, max = 50 }, -- min and max width of the columns
    spacing = 3,                    -- spacing between columns
    align = "left",                 -- align columns left, center or right
  },
  keys = {
    scroll_down = "<c-d>", -- binding to scroll down inside the popup
    scroll_up = "<c-u>",   -- binding to scroll up inside the popup
  },
  ---@type (string|wk.Sorter)[]
  --- Mappings are sorted using configured sorters and natural sort of the keys
  --- Available sorters:
  --- * local: buffer-local mappings first
  --- * order: order of the items (Used by plugins like marks / registers)
  --- * group: groups last
  --- * alphanum: alpha-numerical first
  --- * mod: special modifier keys last
  --- * manual: the order the mappings were added
  --- * case: lower-case first
  sort = { "local", "order", "group", "alphanum", "mod" },
  ---@type number|fun(node: wk.Node):boolean?
  expand = 0, -- expand groups when <= n mappings
  -- expand = function(node)
  --   return not node.desc -- expand all nodes without a description
  -- end,
  -- Functions/Lua Patterns for formatting the labels
  ---@type table<string, ({[1]:string, [2]:string}|fun(str:string):string)[]>
  replace = {
    key = {
      function(key)
        return require("which-key.view").format(key)
      end,
      -- { "<Space>", "SPC" },
    },
    desc = {
      { "<Plug>%(?(.*)%)?", "%1" },
      { "^%+",              "" },
      { "<[cC]md>",         "" },
      { "<[cC][rR]>",       "" },
      { "<[sS]ilent>",      "" },
      { "^lua%s+",          "" },
      { "^call%s+",         "" },
      { "^:%s*",            "" },
    },
  },
  icons = {
    breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
    separator = "➜", -- symbol used between a key and it's label
    group = "+", -- symbol prepended to a group
    ellipsis = "…",
    -- set to false to disable all mapping icons,
    -- both those explicitely added in a mapping
    -- and those from rules
    mappings = true,
    --- See `lua/which-key/icons.lua` for more details
    --- Set to `false` to disable keymap icons from rules
    ---@type wk.IconRule[]|false
    rules = {},
    -- use the highlights from mini.icons
    -- When `false`, it will use `WhichKeyIcon` instead
    --
    colors = true,
    -- used by key format
    keys = {
      Up = " ",
      Down = " ",
      Left = " ",
      Right = " ",
      C = "󰘴 ",
      M = "󰘵 ",
      D = "󰘳 ",
      S = "󰘶 ",
      CR = "󰌑 ",
      Esc = "󱊷 ",
      ScrollWheelDown = "󱕐 ",
      ScrollWheelUp = "󱕑 ",
      NL = "󰌑 ",
      BS = "󰁮",
      Space = "󱁐 ",
      Tab = "󰌒 ",
      F1 = "󱊫",
      F2 = "󱊬",
      F3 = "󱊭",
      F4 = "󱊮",
      F5 = "󱊯",
      F6 = "󱊰",
      F7 = "󱊱",
      F8 = "󱊲",
      F9 = "󱊳",
      F10 = "󱊴",
      F11 = "󱊵",
      F12 = "󱊶",
    },
  },
  show_help = true, -- show a help message in the command line for using WhichKey
  show_keys = true, -- show the currently pressed key and its label as a message in the command line
  -- disable WhichKey for certain buf types and file types.
  disable = {
    ft = {},
    bt = {},
  },
  debug = false, -- enable wk.log in the current directory
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
  { "<leader>-",       "<C-w>s",                                                                                                                                                                                   desc = "Split window below" },
  { "<leader>/",       "<cmd>lua require('telescope').extensions.live_grep_args.live_grep_args({})<CR>",                                                                                                           desc = "Grep with Args" },
  { "<leader><",       "<cmd>lua vim.api.nvim_win_set_width(0, vim.api.nvim_win_get_width(0) - 15)<CR>",                                                                                                           desc = "Decrease Width" },
  { "<leader><s-tab>", "<cmd>tabprevious<cr>",                                                                                                                                                                     desc = "Previous tab" },
  { "<leader><space>", "<cmd>lua require('telescope.builtin').find_files()<cr>",                                                                                                                                   desc = "Find files" },
  { "<leader><tab>",   "<cmd>tabnext<cr>",                                                                                                                                                                         desc = "Next tab" },
  { "<leader>=",       "<C-w>=",                                                                                                                                                                                   desc = "Split Equal" },
  { "<leader>>",       "<cmd>lua vim.api.nvim_win_set_width(0, vim.api.nvim_win_get_width(0) + 15)<CR>",                                                                                                           desc = "Increase Width" },
  { "<leader>B",       "<cmd>b#<cr>",                                                                                                                                                                              desc = "Go back" },
  { "<leader>C",       '<cmd>%bdelete|edit #|normal `"<CR>',                                                                                                                                                       desc = "Close All Window except this one" },
  { "<leader>F",       "<cmd>lua require('telescope.builtin').find_files({no_ignore = true})<cr>",                                                                                                                 desc = "Hidden" },
  { "<leader>O",       "<cmd>lua require('telescope.builtin').treesitter({ query = 'function', symbol_width = 60, previewer = false, initial_mode = normal, layout_config = { width = 0.2, height = 0.2 } })<CR>", desc = "Open Symbols outline" },
  { "<leader>P",       "<cmd>lua vim.fn.setreg('+', vim.fn.expand('%:p'))<CR>",                                                                                                                                    desc = "Copy File Path" },
  { "<leader>T",       "term://zsh<CR>",                                                                                                                                                                           desc = "New Terminal" },
  { "<leader>\\",      "<C-w>v",                                                                                                                                                                                   desc = "Split window right" },
  { "<leader>b",       "<cmd>lua require('telescope.builtin').buffers(require('telescope.themes').get_dropdown({ previewer = false }))<cr>",                                                                       desc = "Buffers" },
  { "<leader>c",       "<cmd>lua require('mini.bufremove').delete(0, false)<CR>",                                                                                                                                  desc = "Close Buffer" },
  { "<leader>d",       "<cmd>Telescope diagnostics bufnr=0<cr>",                                                                                                                                                   desc = "Buffer Diagnostics" },
  { "<leader>e",       "<cmd>Neotree reveal<cr>",                                                                                                                                                                  desc = "Explorer" },
  { "<leader>f",       group = "Find" },
  { "<leader>ff",      "<cmd>lua require('telescope.builtin').find_files()<cr>",                                                                                                                                   desc = "Files" },
  { "<leader>fF",      "<cmd>lua require('telescope.builtin').find_files({no_ignore = true})<cr>",                                                                                                                 desc = "Hidden" },
  { "<leader>fc",      "<cmd>Telescope colorscheme<cr>",                                                                                                                                                           desc = "Colorscheme" },
  { "<leader>fd",      "<cmd>Telescope diagnostics bufnr=0<cr>",                                                                                                                                                   desc = "Document Diagnostics" },
  { "<leader>fg",      "<cmd>Easypick Changed Files<cr>",                                                                                                                                                          desc = "Changed Files" },
  { "<leader>fr",      M.telescope("oldfiles", { cwd = vim.loop.cwd() }),                                                                                                                                          desc = "Recent Files" },
  { "<leader>fo",      "<cmd>Telescope git_status<cr>",                                                                                                                                                            desc = "Open changed file" },
  { "<leader>fw",      "<cmd>Telescope diagnostics<cr>",                                                                                                                                                           desc = "Workspace Diagnostics" },
  { "<leader>p",       group = "Packer" },
  { "<leader>pS",      "<cmd>PackerStatus<cr>",                                                                                                                                                                    desc = "Status" },
  { "<leader>pc",      "<cmd>PackerCompile<cr>",                                                                                                                                                                   desc = "Compile" },
  { "<leader>pi",      "<cmd>PackerInstall<cr>",                                                                                                                                                                   desc = "Install" },
  { "<leader>ps",      "<cmd>PackerSync<cr>",                                                                                                                                                                      desc = "Sync" },
  { "<leader>pu",      "<cmd>PackerUpdate<cr>",                                                                                                                                                                    desc = "Update" },
  { "<leader>g",       group = "Git" },
  { "<leader>sM",      "<cmd>Telescope man_pages<cr>",                                                                                                                                                             desc = "Man Pages" },
  { "<leader>sS",      M.telescope("lsp_workspace_symbols"),                                                                                                                                                       desc = "Workspace Symbols" },
  { "<leader>sa",      "<cmd>Telescope autocommands<cr>",                                                                                                                                                          desc = "Auto Commands" },
  { "<leader>sc",      "<cmd>Telescope commands<cr>",                                                                                                                                                              desc = "Commands" },
  { "<leader>sg",      "<cmd> lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>",                                                                                                            desc = "Grep with Args" },
  { "<leader>sk",      "<cmd>Telescope keymaps<cr>",                                                                                                                                                               desc = "Keymaps" },
  { "<leader>sm",      "<cmd>Telescope marks<cr>",                                                                                                                                                                 desc = "Search Marks" },
  { "<leader>ss",      M.telescope("lsp_document_symbols", { symbols = { "Class", "Function", "Method", "Constructor", "Interface", "Module", "Struct", "Trait", "Field", "Property" } }),                         desc = "Document Symbols" },
  { "<leader>sw",      M.telescope("lsp_workspace_symbols"),                                                                                                                                                       desc = "Word" },
  { "<leader>s",       group = "Search" },
  { "<leader>gg",      "<cmd>lua LAZYGIT_TOGGLE()<CR>",                                                                                                                                                            desc = "Lazygit" },
  { "<leader>gd",      "<cmd>Gitsigns diffthis HEAD<cr>",                                                                                                                                                          desc = "Diff" },
  { "<leader>go",      "<cmd>Telescope git_status<cr>",                                                                                                                                                            desc = "Open changed file" },
  { "<leader>l",       group = "LSP" },
  { "<leader>la",      "<cmd>lua vim.lsp.buf.code_action()<cr>",                                                                                                                                                   desc = "Code Action" },
  { "<leader>lf",      "<cmd>lua vim.lsp.buf.format{async=true}<cr>",                                                                                                                                              desc = "Format" },
  { "<leader>ll",      "<cmd>LspInfo<cr>",                                                                                                                                                                         desc = "Info" },
  { "<leader>lL",      "<cmd>LspLog<cr>",                                                                                                                                                                          desc = "Lsp Log" },
  { "<leader>ln",      "<cmd>NullLsInfo<cr>",                                                                                                                                                                      desc = "Null LS Info" },
  { "<leader>lN",      "<cmd>NullLsLog<CR>",                                                                                                                                                                       desc = "Null LS Log" },
  { "<leader>lq",      "<cmd>lua vim.diagnostic.setloclist()<cr>",                                                                                                                                                 desc = "Quickfix" },
  { "<leader>lr",      "<cmd>lua vim.lsp.buf.rename()<cr>",                                                                                                                                                        desc = "Rename" },
  { "<leader>rr",      group = "Rails" },
  { "<leader>rb",      "<cmd>lua DOCKER_BASH_TOGGLE()<cr>",                                                                                                                                                        desc = "Docker Bash" },
  { "<leader>rd",      "<cmd>lua DOCKER_UP_TOGGLE()<cr>",                                                                                                                                                          desc = "Docker up" },
  { "<leader>rf",      "<cmd>lua RAILS_FOREMAN_TOGGLE()<cr>",                                                                                                                                                      desc = "Foreman" },
  { "<leader>rn",      "<cmd>lua NPM_SERVER_TOGGLE()<cr>",                                                                                                                                                         desc = "NPM server" },
  { "<leader>rrb",     "<cmd>lua BYEBUG_SERVER_TOGGLE()<cr>",                                                                                                                                                      desc = "Byebug server" },
  { "<leader>rrr",     "<cmd>lua RAILS_ROUTES_TOGGLE()<cr>",                                                                                                                                                       desc = "Rails Routes" },
  { "<leader>rrc",     "<cmd>lua RAILS_CONSOLE_TOGGLE()<cr>",                                                                                                                                                      desc = "Rails Console" },
  { "<leader>r",       group = "Run" },
  { "<leader>rs",      "<cmd>lua RAILS_SERVER_TOGGLE()<cr>",                                                                                                                                                       desc = "Rails Server" },
  { "<leader>ry",      "<cmd>lua YARN_SERVER_TOGGLE()<cr>",                                                                                                                                                        desc = "Yarn Start" },
  { "<leader>n",       group = "Noice" },
  { "<leader>nd",      "<cmd>NoiceDismiss<cr>",                                                                                                                                                                    desc = "Dismiss" },
  { "<leader>nh",      "<cmd>NoiceHistory<cr>",                                                                                                                                                                    desc = "History" },
  { "<leader>t",       group = "Terminal" },
  { "<leader>tt",      ":vsplit term://zsh<CR>",                                                                                                                                                                   desc = "New Split Terminal" },
  { "<leader>tf",      "<cmd>ToggleTerm direction=float<cr>",                                                                                                                                                      desc = "Float" },
  { "<leader>th",      "<cmd>ToggleTerm size=18 direction=horizontal<cr>",                                                                                                                                         desc = "Horizontal" },
  { "<leader>tv",      "<cmd>ToggleTerm size=220 direction=vertical<cr>",                                                                                                                                          desc = "Vertical" },
  { "<leader>j",       "<cmd>lua vim.api.nvim_win_set_height(0, vim.api.nvim_win_get_height(0) - 15)<CR>",                                                                                                         desc = "Decrease Height" },
  { "<leader>k",       "<cmd>lua vim.api.nvim_win_set_height(0, vim.api.nvim_win_get_height(0) + 15)<CR>",                                                                                                         desc = "Increase Height" },
  { "<leader>u",       "<cmd>UndotreeToggle<CR>",                                                                                                                                                                  desc = "Undo Tree" },
  { "<leader>x",       "<cmd>quit<CR>",                                                                                                                                                                            desc = "Close Split" },
  { "<leader>w",       "<cmd>lua vim.lsp.buf.format{async=true}<cr>",                                                                                                                                              desc = "Format" },
  { "<leader>q",       "<cmd>copen<cr>",                                                                                                                                                                           desc = "Open Quickfix" }
}

which_key.setup(setup)
which_key.add(mappings, opts)
