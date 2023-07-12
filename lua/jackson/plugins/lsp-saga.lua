local setup, lspsaga = pcall(require, "lspsaga")
if not setup then
	return
end

lspsaga.setup({
	"glepnir/lspsaga.nvim",
	event = "LspAttach",
  symbols_in_winbar = true,
	preview = {
		lines_above = 0,
		lines_below = 10,
	},
	scroll_preview = {
		scroll_down = "<C-n>",
		scroll_up = "<C-p>",
	},
	request_timeout = 5000,

	-- See Customizing Lspsaga's Appearance
	ui = {
		-- This option only works in Neovim 0.9
		title = true,
		-- Border type can be single, double, rounded, solid, shadow.
		border = "rounded",
		winblend = 0,
		expand = "",
		collapse = "",
		code_action = "💡",
		incoming = " ",
		outgoing = " ",
		hover = " ",
		kind = {},
	},

	outline = {
		win_position = "right",
		-- win_width = 30,
		preview_width = 1.2,
		-- detail = true,
		-- close_after_jump = true,
		-- auto_preview = true,
		-- show_detail = true,
		-- auto_refresh = true,
		-- auto_close = true,
		-- auto_resize = true,
		-- custom_sort = nil,
		-- keys = {
		-- 	toggle_or_jump = "o",
		-- 	quit = "q",
		-- },
	},

	-- For default options for each command, see below
	finder = {
		max_height = 0.5,
		min_width = 5,
		force_max_height = false,
		keys = {
			jump_to = "p",
			expand_or_jump = "o",
			vsplit = "s",
			split = "i",
			tabe = "t",
			tabnew = "r",
			quit = { "q", "<ESC>" },
			close_in_preview = "<ESC>",
		},
	},

	code_action = {
		num_shortcut = true,
		show_server_name = true,
		extend_gitsigns = true,
		keys = {
			-- string | table type
			quit = "q",
			exec = "<CR>",
		},
	},

	lightbulb = {
		enable = true,
		enable_in_insert = true,
		sign = true,
		sign_priority = 40,
		virtual_text = true,
	},
})
