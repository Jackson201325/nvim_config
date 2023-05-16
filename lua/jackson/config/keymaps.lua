vim.g.mapleader = " "
vim.g.localmapleader = " "
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

local keymap = vim.keymap
local opts = { noremap = true, silent = true }

-- keymap.set("n", "j", "j", opts)
-- keymap.set("n", "dw", "viwdi", opts)
-- keymap.set("n", "cw", "ciw", opts)
-- keymap.set("n", "pw", "viw<C-p>", opts)
-- keymap.set("n", "yw", "viwy", opts)

-- Do not yank with x
keymap.set("n", "x", '"_x', opts)

-- Do not yank with c
keymap.set({ "n", "v" }, "c", '"_c', opts)

--Do not yank with dd
-- keymap.set("n", "dd", '"_dd', opts)

--To set in the cursor in the middle when jumping
keymap.set("n", "<C-d>", "<C-d>zz", opts)
keymap.set("n", "<C-u>", "<C-u>zz", opts)
keymap.set("n", "(", "{zz", opts)
keymap.set("n", ")", "}zz", opts)
-- keymap.set("n", "{", "{zz", opts)
-- keymap.set("n", "}", "}zz", opts)
keymap.set("n", "n", "nzzzv", opts)
keymap.set("n", "N", "Nzzzv", opts)

-- Paste over
keymap.set("x", "<C-p>", '"_dP', opts)

-- Delete a word backwards
keymap.set("n", "dw", 'vb"_d', opts)

-- Select all
keymap.set("n", "<C-a>", "gg<S-v>G", opts)

-- Move line of code
keymap.set("v", "<A-Down>", ":m '>+1<CR>gv=gv", opts)
keymap.set("v", "<A-Up>", ":m '<-2<CR>gv=gv", opts)
keymap.set("n", "<A-Down>", ":m .+1<CR>==", opts)
keymap.set("n", "<A-Up>", ":m .-2<CR>==", opts)
keymap.set("i", "<A-Down>", "<esc>:m .+1<CR>==", opts)
keymap.set("i", "<A-Up>", "<esc>:m .-2<CR>==", opts)

-- save file
keymap.set({ "i", "v", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", opts)

-- quit
keymap.set("n", "<C-q>", ":qa<cr>", { desc = "Quit all" })

-- Faster esc
keymap.set("t", "<esc><esc>", "<c-\\><c-n>", opts)
keymap.set("i", "jk", "<ESC>", opts)
keymap.set("n", "0", "^", opts)

-- Move to window using the <ctrl> hjkl keys
keymap.set("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
keymap.set("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
keymap.set("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
keymap.set("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

-- better indenting
keymap.set("v", ">", ">gv", opts)
keymap.set("v", "<", "<gv", opts)

-- keymap.set("n", "<Tab>", ">>", opts)
-- keymap.set("n", "<S-Tab>", "<<", opts)
-- keymap.set("i", "<Tab>", "<C-t>", opts)
-- keymap.set("i", "<S-Tab>", "<C-d>", opts)

-- Clear search with <esc>
keymap.set({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", opts)

-- highlights under cursor
if vim.fn.has("nvim-0.9.0") == 1 then
	keymap.set("n", "<leader>ui", vim.show_pos, { desc = "Inspect Pos" })
end

-- windows
keymap.set("n", "<leader>x", ":close<CR>", { desc = "Close Split" })
keymap.set("n", "<leader>=", "<C-w>=", { desc = "Split Equal" })
keymap.set("n", "<leader>-", "<C-w>s", { desc = "Split window below" })
keymap.set("n", "<leader>\\", "<C-w>v", { desc = "Split window right" })

-- search word under cursor
keymap.set({ "n", "x" }, "gw", "*N", { desc = "Search word under cursor" })

keymap.set("n", "<S-h>", ":bprevious<cr>", { desc = "Prev buffer" })
keymap.set("n", "<S-l>", ":bnext<cr>", { desc = "Next buffer" })

-- Telescope keymaps
keymap.set("n", "<leader>/", "<cmd>Telescope live_grep<CR>", { desc = "Grep (root dir)" })

-- find
keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Find File" })
keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "Recent" })

-- search
keymap.set("n", "<leader>sC", "<cmd>Telescope commands<cr>", { desc = "Commands" })
keymap.set("n", "<leader>sh", "<cmd>Telescope help_tags<cr>", { desc = "Help Pages" })
keymap.set("n", "<leader>sH", "<cmd>Telescope highlights<cr>", { desc = "Search Highlight Groups" })
keymap.set("n", "<leader>sk", "<cmd>Telescope keymaps<cr>", { desc = "Key Maps" })

-- Useless keymaps

-- Normal mode
-- F = Foward
-- B = backwards
-- CTRL + F goes N numbers of screen
-- CTRL + B goes N numbers of screen
-- CTRL + P goes one up like k
--
--
-- In Insert mode
-- CTRL + X = prefix for suggestion
