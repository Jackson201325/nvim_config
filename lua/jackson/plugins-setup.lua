local fn = vim.fn

local ensure_packer = function()
  local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
    vim.cmd([[packadd packer.nvim]])
    return true
  end
  return false
end

vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
  augroup end
]])

local packer_bootstrap = ensure_packer()

local status_ok, packer = pcall(require, "packer")
if not status_ok then
  return
end

packer.startup(function(use)
  use("wbthomason/packer.nvim")

  -- My plugins here
  use("nvim-lua/plenary.nvim")
  use("nvim-lua/popup.nvim")

  -- Color scheme
  use("folke/tokyonight.nvim")

  use({
    "kylechui/nvim-surround",
    tag = "*", -- Use for stability; omit to use `main` branch for the latest features
    config = function()
      require("nvim-surround").setup({})
    end,
  })
  -- CMP plugins
  use("hrsh7th/nvim-cmp")    -- Autocompletion plugin
  use("hrsh7th/cmp-buffer")  -- Autocompletion for buffers
  use("hrsh7th/cmp-path")    -- Autocompletion for paths
  use("hrsh7th/cmp-cmdline") -- Autocompletion for cmdline
  use("hrsh7th/cmp-nvim-lsp")
  use("onsails/lspkind-nvim")

  -- snippets
  use("L3MON4D3/LuaSnip")             -- Snippets plugin
  use("saadparwaiz1/cmp_luasnip")     -- Autocompletion for snippets
  use("rafamadriz/friendly-snippets") -- Snippets collection

  -- LSP
  use("williamboman/mason.nvim")
  use("williamboman/mason-lspconfig.nvim")
  use("neovim/nvim-lspconfig")
  use("nvimtools/none-ls.nvim")
  use("folke/neodev.nvim")
  use("kchmck/vim-coffee-script")
  use({
    "pmizio/typescript-tools.nvim",
    requires = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    config = function()
      require("typescript-tools").setup({
        on_attach = function(client)
          client.server_capabilities.documentFormattingProvider = false
          client.server_capabilities.documentRangeFormattingProvider = false
        end,

        settings = {
          -- spawn additional tsserver instance to calculate diagnostics on it
          separate_diagnostic_server = true,
          -- "change"|"insert_leave" determine when the client asks the server about diagnostic
          publish_diagnostic_on = "insert_leave",
          -- array of strings("fix_all"|"add_missing_imports"|"remove_unused"|
          -- "remove_unused_imports"|"organize_imports") -- or string "all"
          -- to include all supported code actions
          -- specify commands exposed as code_actions
          expose_as_code_action = {},
          -- string|nil - specify a custom path to `tsserver.js` file, if this is nil or file under path
          -- not exists then standard path resolution strategy is applied
          tsserver_path = nil,
          -- specify a list of plugins to load by tsserver, e.g., for support `styled-components`
          -- (see 💅 `styled-components` support section)
          tsserver_plugins = {
            "@styled/typescript-styled-plugin",
          },
          -- this value is passed to: https://nodejs.org/api/cli.html#--max-old-space-sizesize-in-megabytes
          -- memory limit in megabytes or "auto"(basically no limit)
          tsserver_max_memory = "auto",
          -- described below
          tsserver_format_options = {},
          tsserver_file_preferences = {},
          -- locale of all tsserver messages, supported locales you can find here:
          -- https://github.com/microsoft/TypeScript/blob/3c221fc086be52b19801f6e8d82596d04607ede6/src/compiler/utilitiesPublic.ts#L620
          tsserver_locale = "en",
          -- mirror of VSCode's `typescript.suggest.completeFunctionCalls`
          complete_function_calls = false,
          include_completions_with_insert_text = true,
          -- CodeLens
          -- WARNING: Experimental feature also in VSCode, because it might hit performance of server.
          -- possible values: ("off"|"all"|"implementations_only"|"references_only")
          code_lens = "off",
          -- by default code lenses are displayed on all referencable values and for some of you it can
          -- be too much this option reduce count of them by removing member references from lenses
          disable_member_code_lens = true,
          -- JSXCloseTag
          -- WARNING: it is disabled by default (maybe you configuration or distro already uses nvim-ts-autotag,
          -- that maybe have a conflict if enable this feature. )
          jsx_close_tag = {
            enable = false,
            filetypes = { "javascriptreact", "typescriptreact" },
          },
        },
      })
    end,
  })
  use({
    "nvimdev/lspsaga.nvim",
    after = "nvim-lspconfig",
    config = function()
      require("lspsaga").setup({
        symbol_in_winbar = {
          enable = false,
        },
      })
    end,
  })

  -- Telescope
  use("nvim-telescope/telescope.nvim")
  use("nvim-telescope/telescope-live-grep-args.nvim")
  use({
    "nvim-telescope/telescope-fzf-native.nvim",
    run =
    "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
  })
  use("nvim-telescope/telescope-project.nvim")

  -- Coding
  use({
    "nvim-pack/nvim-spectre",
    config = function()
      require("spectre").setup()
    end,
  })
  use("windwp/nvim-ts-autotag")
  use("windwp/nvim-autopairs")
  use("nvim-treesitter/nvim-treesitter", { run = ":TSUpdate" })
  use({
    "nvim-treesitter/nvim-treesitter-context",
    config = function()
      require("treesitter-context").setup({
        max_lines = 2,
        multiline_threshold = 2,
      })
    end,
  })
  use("numToStr/Comment.nvim")
  use({
    "ahmedkhalf/project.nvim",
    config = function()
      require("project_nvim").setup({ ---@usage set to false to disable project.nvim.
        --- This is on by default since it's currently the expected behavior.
        active = true,

        on_config_done = nil,

        ---@usage set to true to disable setting the current-woriking directory
        --- Manual mode doesn't automatically change your root directory, so you have
        --- the option to manually do so using `:ProjectRoot` command.
        manual_mode = false,

        ---@usage Methods of detecting the root directory
        --- Allowed values: **"lsp"** uses the native neovim lsp
        --- **"pattern"** uses vim-rooter like glob pattern matching. Here
        --- order matters: if one is not detected, the other is used as fallback. You
        --- can also delete or rearangne the detection methods.
        -- detection_methods = { "lsp", "pattern" }, -- NOTE: lsp detection will get annoying with multiple langs in one project
        detection_methods = { "pattern" },

        ---@usage patterns used to detect root dir, when **"pattern"** is in detection_methods
        patterns = { ".git" },

        ---@ Show hidden files in telescope when searching for files in a project
        show_hidden = false,

        ---@usage When set to false, you will get a message when project.nvim changes your directory.
        -- When set to false, you will get a message when project.nvim changes your directory.
        silent_chdir = true,

        ---@usage list of lsp client names to ignore when using **lsp** detection. eg: { "efm", ... }
        ignore_lsp = {},

        ---@type string
        ---@usage path to store the project history for use in telescope
        datapath = vim.fn.stdpath("data"),
      })
    end,
  })
  use({
    "cappyzawa/trim.nvim",
    config = function()
      require("trim").setup({})
    end,
  })
  use({
    "nvim-treesitter/nvim-treesitter-textobjects",
    after = "nvim-treesitter",
    requires = "nvim-treesitter/nvim-treesitter",
  })
  use({ "mg979/vim-visual-multi", branch = "master" })

  -- UI
  use("roobert/tailwindcss-colorizer-cmp.nvim")
  use("lewis6991/gitsigns.nvim")
  use("xiyaowong/transparent.nvim")
  use("goolord/alpha-nvim")
  use("NvChad/nvim-colorizer.lua")
  use("folke/which-key.nvim")
  use("RRethy/vim-illuminate")
  use({
    "RRethy/nvim-treesitter-endwise",
    after = "nvim-treesitter",
    requires = "nvim-treesitter/nvim-treesitter",
    config = function()
      require("nvim-treesitter.configs").setup({
        endwise = {
          enable = true,
        },
      })
    end,
  })
  use({ "kevinhwang91/nvim-ufo", requires = "kevinhwang91/promise-async" })
  use({ "kevinhwang91/nvim-bqf", ft = "qf" })
  use({
    "folke/noice.nvim",
    requires = { "MunifTanjim/nui.nvim" },
  })

  -- Movement
  use("mbbill/undotree")
  use("christoomey/vim-tmux-navigator")
  use("tpope/vim-repeat")
  use("folke/flash.nvim")

  -- Neo Tree
  use({
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    requires = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
    },
  })

  -- Toggle terminal
  use({
    "akinsho/toggleterm.nvim",
    tag = "*",
  })

  -- Bufferline
  use("akinsho/bufferline.nvim")

  -- Status line
  use("nvim-lualine/lualine.nvim")

  -- Copilot
  use({
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        panel = {
          enabled = true,
          auto_refresh = false,
          keymap = {
            jump_prev = "[[",
            jump_next = "]]",
            accept = "<CR>",
            refresh = "gr",
            open = "<M-CR>",
          },
          layout = {
            position = "bottom", -- | top | left | right
            ratio = 0.4,
          },
        },
        suggestion = {
          enabled = true,
          auto_trigger = false,
          debounce = 75,
          keymap = {
            accept = "<M-l>",
            accept_word = false,
            accept_line = false,
            next = "<M-]>",
            prev = "<M-[>",
            dismiss = "<C-]>",
          },
        },
        filetypes = {
          yaml = false,
          markdown = false,
          help = false,
          gitcommit = false,
          gitrebase = false,
          hgcommit = false,
          svn = false,
          cvs = false,
          ["."] = false,
        },
        copilot_node_command = "node", -- Node.js version must be > 16.x
        server_opts_overrides = {},
      })
    end,
  })
  use({
    "zbirenbaum/copilot-cmp",
    after = { "copilot.lua" },
    config = function()
      require("copilot_cmp").setup({
        suggestion = { enabled = false },
        panel = { enabled = false },
      })
    end,
  })

  -- Sessions Management
  use("olimorris/persisted.nvim")

  -- Indentation line
  use({
    "lukas-reineke/indent-blankline.nvim",
    config = function()
      require("ibl").setup({
        exclude = {
          filetypes = {
            "help",
            "alpha",
            "dashboard",
            "neo-tree",
            "terminal",
            "lspsaga",
            "Trouble",
            "lazy",
            "mason",
            "notify",
            "toggleterm",
            "lazyterm",
          },
        },
        scope = {
          enabled = false,
          show_end = false,
          show_start = false,
        },
        indent = { char = "│" },
      })
    end,
  })

  use({
    "echasnovski/mini.indentscope",
    config = function()
      require("mini.indentscope").setup({
        -- Draw options
        draw = {
          -- Delay (in ms) between event and start of drawing scope indicator
          delay = 50,

          -- Animation rule for scope's first drawing. A function which, given
          -- next and total step numbers, returns wait time (in ms). See
          -- |MiniIndentscope.gen_animation| for builtin options. To disable
          -- animation, use `require('mini.indentscope').gen_animation.none()`.
          -- animation = --<function: implements constant 20ms between steps>,

          -- Symbol priority. Increase to display on top of more symbols.
          priority = 2,
        },

        -- Module mappings. Use `''` (empty string) to disable one.
        mappings = {
          -- Textobjects
          object_scope = "ii",
          object_scope_with_border = "ai",

          -- Motions (jump to respective border line; if not present - body line)
          goto_top = "[i",
          goto_bottom = "]i",
        },
        options = {
          -- Type of scope's border: which line(s) with smaller indent to
          -- categorize as border. Can be one of: 'both', 'top', 'bottom', 'none'.
          border = "both",

          -- Whether to use cursor column when computing reference indent.
          -- Useful to see incremental scopes with horizontal cursor movements.
          indent_at_cursor = true,

          -- Whether to first check input line to be a border of adjacent scope.
          -- Use it if you want to place cursor on function header to get scope of
          -- its body.
          try_as_border = false,
        },

        -- Which character to use for drawing scope indicator
        symbol = "│",
      })
    end,
  })

  -- Delete buffer but not split
  use("echasnovski/mini.bufremove")

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require("packer").sync()
  end
end)
