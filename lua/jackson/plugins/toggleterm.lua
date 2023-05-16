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

local node = terminal:new({ cmd = "node", hidden = true })

function NODE_TOGGLE()
	node:toggle()
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
	open_mapping = [[<C-t>]],
	hide_numbers = true,
	shade_filetypes = {},
	shade_terminals = true,
	shading_factor = 2,
	start_in_insert = true,
	insert_mappings = true,
	persist_size = true,
	direction = "float",
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
--
-- function _g.set_terminal_keymaps()
-- 	local opts = { noremap = true }
-- 	vim.api.nvim_buf_set_keymap(0, "t", "<esc>", [[<c-\><c-n>]], opts)
-- 	vim.api.nvim_buf_set_keymap(0, "t", "<c-h>", [[<c-\><c-n><c-w>h]], opts)
-- 	vim.api.nvim_buf_set_keymap(0, "t", "<c-j>", [[<c-\><c-n><c-w>j]], opts)
-- 	vim.api.nvim_buf_set_keymap(0, "t", "<c-k>", [[<c-\><c-n><c-w>k]], opts)
-- 	vim.api.nvim_buf_set_keymap(0, "t", "<c-l>", [[<c-\><c-n><c-w>l]], opts)
-- end
--
-- vim.cmd("autocmd! termopen term://* lua set_terminal_keymaps()")
--
-- local terminal = toggleterm.terminal
-- local lazygit = terminal:new({ cmd = "lazygit", hidden = true })

-- function LAZYGIT_TOGGLE()
-- 	lazygit:toggle()
-- end

-- local node = terminal:new({ cmd = "node", hidden = true })
--
-- function _node_toggle()
-- 	node:toggle()
-- end
--
-- local ncdu = terminal:new({ cmd = "ncdu", hidden = true })
--
-- function _ncdu_toggle()
-- 	ncdu:toggle()
-- end
--
-- local htop = terminal:new({ cmd = "htop", hidden = true })
--
-- function _htop_toggle()
-- 	htop:toggle()
-- end
--
-- local python = terminal:new({ cmd = "python", hidden = true })
--
-- function _python_toggle()
-- 	python:toggle()
-- end
