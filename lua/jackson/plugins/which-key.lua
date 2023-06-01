local status_ok, which_key = pcall(require, "which-key")
if not status_ok then
	return
end

local setup = {
	plugins = {
		marks = true, -- shows a list of your marks on ' and `
		registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
		spelling = {
			enabled = true, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
			suggestions = 20, -- how many suggestions should be shown in the list?
		},
		-- the presets plugin, adds help for a bunch of default keybindings in Neovim
		-- No actual key bindings are created
		presets = {
			operators = false, -- adds help for operators like d, y, ... and registers them for motion / text object completion
			motions = true, -- adds help for motions
			text_objects = true, -- help for text objects triggered after entering an operator
			windows = true, -- default bindings on <c-w>
			nav = true, -- misc bindings to work with windows
			z = true, -- bindings for folds, spelling and others prefixed with z
			g = true, -- bindings for prefixed with g
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
		breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
		separator = "➜", -- symbol used between a key and it's label
		group = "+", -- symbol prepended to a group
	},
	popup_mappings = {
		scroll_down = "<c-d>", -- binding to scroll down inside the popup
		scroll_up = "<c-u>", -- binding to scroll up inside the popup
	},
	window = {
		border = "rounded", -- none, single, double, shadow
		position = "bottom", -- bottom, top
		margin = { 1, 0, 1, 0 }, -- extra window margin [top, right, bottom, left]
		padding = { 2, 2, 2, 2 }, -- extra window padding [top, right, bottom, left]
		winblend = 0,
	},
	layout = {
		height = { min = 4, max = 25 }, -- min and max height of the columns
		width = { min = 20, max = 50 }, -- min and max width of the columns
		spacing = 3, -- spacing between columns
		align = "left", -- align columns left, center or right
	},
	ignore_missing = true, -- enable this to hide mappings for which you didn't specify a label
	hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ " }, -- hide mapping boilerplate
	show_help = true, -- show help message on the command line when the popup is visible
	triggers = "auto", -- automatically setup triggers
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
	mode = "n", -- NORMAL mode
	prefix = "<leader>",
	buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
	silent = true, -- use `silent` when creating keymaps
	noremap = true, -- use `noremap` when creating keymaps
	nowait = true, -- use `nowait` when creating keymaps
}

local mappings = {
	["a"] = { ":SymbolsOutline<CR>", "Open Symbols Outline" },
	["C"] = { '<cmd>%bdelete|edit #|normal `"<CR>', "Close All Window except this one" },
	["c"] = { "<cmd>lua require('mini.bufremove').delete(0, false)<CR>", "Close Buffer" },
	["e"] = { "<cmd>Neotree toggle<cr>", "Explorer" },
	["h"] = { "<cmd>nohlsearch<CR>", "No Highlight" },
	["o"] = { "<cmd>Lspsaga outline<CR>", "Open LSP outline" },
	["u"] = { "<cmd>UndotreeToggle<CR>", "Undo Tree" },
	["x"] = { "<cmd>quit<CR>", "Close Split" },
	["X"] = { "<cmd>lua require('mini.bufremove').delete(0, true)<CR>", "Force Close Buffer" },
	["w"] = { "<cmd>lua vim.lsp.buf.format{async=true}<CR>", "Format" },
	["<space>"] = { "<cmd>Telescope git_status<cr>", "Find Changed files" },
	["/"] = { "<cmd>Telescope live_grep<CR>", "Grep" },
	["="] = { "<C-w>=", "Split Equal" },
	["-"] = { "<C-w>s", "Split window below" },
	["\\"] = { "<C-w>v", "Split window right" },
	f = {
		name = "Find",
		c = { "<cmd>Telescope colorscheme<cr>", "Colorscheme" },
		d = {
			"<cmd>Telescope diagnostics bufnr=0<cr>",
			"Document Diagnostics",
		},
		g = { "<cmd> lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>", "Grep with Args" },
		f = {
			"<cmd>lua require('telescope.builtin').find_files()<cr>",
			"Files",
		},
		F = { "<cmd>Telescope find_files hidden=true<cr>", "Hidden" },
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
		b = { "<cmd>Lspsaga show_buf_diagnostics<cr>", "Buffer Diagnostics" },
		c = { "<cmd>Telescope commands<cr>", "Commands" },
		k = { "<cmd>Telescope keymaps<cr>", "Keymaps" },
		m = { "<cmd>Telescope man_pages<cr>", "Man Pages" },
		s = { "<cmd>Telescope lsp_document_symbols<cr>", "Document Symbols" },
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
		i = { "<cmd>LspInfo<cr>", "Info" },
		I = { "<cmd>LspLog<cr>", "Lsp Log" },
		n = { "<cmd>NullLsInfo<cr>", "Null LS Info" },
		N = { "<cmd>NullLsLog<CR>", "Null LS Log" },
		o = { "<cmd>Lspsaga lsp_finder<cr>", "LSP Finder" },
		q = { "<cmd>lua vim.diagnostic.setloclist()<cr>", "Quickfix" },
		r = { "<cmd>lua vim.lsp.buf.rename()<cr>", "Rename" },
	},

	t = {
		name = "Terminal",
		n = { "<cmd>lua NODE_TOGGLE()<cr>", "Node" },
		u = { "<cmd>lua NCDU_TOGGLE()<cr>", "NCDU" },
		t = { "<cmd>lua HTOP_TOGGLE()<cr>", "Htop" },
		f = { "<cmd>ToggleTerm direction=float<cr>", "Float" },
		h = { "<cmd>ToggleTerm size=10 direction=horizontal<cr>", "Horizontal" },
		v = { "<cmd>ToggleTerm size=80 direction=vertical<cr>", "Vertical" },
	},

	d = {
		name = "Diagnostics",
		x = { "<cmd>TroubleToggle<cr>", "TroubleToggle" },
		w = { "<cmd>TroubleToggle workspace_diagnostics<cr>", "Workspace Diagnostics" },
		d = { "<cmd>TroubleToggle document_diagnostics<cr>", "Document Diagnostics" },
		l = { "<cmd>TroubleToggle loclist<cr>", "Loclist" },
		q = { "<cmd>TroubleToggle quickfix<cr>", "Quickfix" },
		r = { "<cmd>TroubleToggle lsp_references<cr>", "LSP References" },
	},
}

which_key.setup(setup)
which_key.register(mappings, opts)
