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

-- Minus Plus
keymap.set("n", "=", "<C-a>", opts)
keymap.set("n", "-", "<C-x>", opts)

-- Jump back
keymap.set("n", "<C-o>", "<C-o>zz", opts)
-- keymap.set("n", "<C-i>", "<Tab>zz", opts)

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
-- keymap.set("t", "<esc><esc>", "<c-\\><c-n>", opts)
keymap.set("i", "jj", "<cmd>noh<cr><ESC>", opts)
keymap.set("i", "kk", "<cmd>noh<cr><ESC>", opts)
keymap.set("i", "kj", "<cmd>noh<cr><ESC>", opts)
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
-- if vim.fn.has("nvim-0.9.0") == 1 then
-- 	keymap.set("n", "<leader>ui", vim.show_pos, { desc = "Inspect Pos" })
-- end
--

-- search word under cursor
keymap.set({ "n", "x" }, "gw", "*N", { desc = "Search word under cursor" })

-- Move between buffers
keymap.set("n", "<S-h>", ":bprevious<cr>", { desc = "Prev buffer" })
keymap.set("n", "<S-l>", ":bnext<cr>", { desc = "Next buffer" })

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
