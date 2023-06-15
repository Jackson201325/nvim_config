local status_ok, toggleterm = pcall(require, "toggleterm")
if not status_ok then
	return
end

local terminal = require("toggleterm.terminal").Terminal

local lazygit = terminal:new({
	cmd = "lazygit",
	dir = "git_dir",
	direction = "float",
	float_opts = {
		border = "curved",
	},
	-- function to run on opening the terminal
	on_open = function(term)
		vim.cmd("startinsert!")
		vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
	end,
	-- function to run on closing the terminal
	on_close = function()
		vim.cmd("startinsert!")
	end,
})

function LAZYGIT_TOGGLE()
	lazygit:toggle()
end

local rails_server = terminal:new({ cmd = "bundle exec rails s", hidden = true })

function RAILS_TOGGLE()
	rails_server:toggle()
end

local ncdu = terminal:new({ cmd = "ncdu", hidden = true })

function NCDU_TOGGLE()
	ncdu:toggle()
end

local htop = terminal:new({ cmd = "htop", hidden = true })

function HTOP_TOGGLE()
	htop:toggle()
end

local python = terminal:new({ cmd = "python", hidden = true })

function PYTHON_TOGGLE()
	python:toggle()
end

toggleterm.setup({
	size = 20,
	open_mapping = [[<c-t>]],
	hide_numbers = true,
	shade_filetypes = {},
	shade_terminals = true,
	shading_factor = 2,
	start_in_insert = true,
	insert_mappings = true,
	persist_size = true,
	direction = "horizontal",
	close_on_exit = true,
	shell = vim.o.shell,
	float_opts = {
		border = "curved",
		winblend = 0,
		highlights = {
			border = "normal",
			background = "normal",
		},
	},
})
