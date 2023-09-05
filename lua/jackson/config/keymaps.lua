vim.g.mapleader = " "
vim.g.localmapleader = " "
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

local keymap = vim.keymap
local opts = { noremap = true, silent = true }
local live_grep_args_shortcuts = require("telescope-live-grep-args.shortcuts")

-- Minus Plus
keymap.set("n", "=", "<C-a>", opts)
keymap.set("n", "-", "<C-x>", opts)

-- Jump back
keymap.set("n", "<C-o>", "<C-o>zz", opts)
keymap.set("n", "<C-i>", "<C-i>zz", opts)

-- Do not yank with x
keymap.set("n", "x", '"_x', opts)

-- Do not yank with c
keymap.set({ "n", "v" }, "c", '"_c', opts)

-- Do not yank with dd
-- keymap.set("n", "dd", '"_dd', opts)

keymap.set({ "n" }, "vw", "viw")
keymap.set({ "n" }, "vp", 'viw"_dP')
keymap.set({ "n" }, "vP", 'viW"_dP')

keymap.set({ "n" }, "dw", "viwd")
keymap.set({ "n" }, "dW", "viWd")

keymap.set({ "n" }, "yw", "viwy")
keymap.set({ "n" }, "yW", "viWy")

keymap.set({ "n" }, "cw", "viwc")
keymap.set({ "n" }, "cW", "viWc")

-- --To set in the cursor in the middle when jumping
-- keymap.set("n", "(", "{zz", opts)
-- keymap.set("n", ")", "}zz", opts)

--To set in the cursor in the middle when jumping
keymap.set({ "n", "v" }, ")", "{", opts)
keymap.set({ "n", "v" }, "(", "}", opts)

--To set in the cursor in the middle when jumping
keymap.set({ "n", "v" }, "}", "{", opts)
keymap.set({ "n", "v" }, "{", "}", opts)

keymap.set("n", "N", "Nzz", opts)
keymap.set("n", "n", "nzz", opts)

keymap.set("n", "<C-u>", "<C-u>zz", opts)
keymap.set("n", "<C-d>", "<C-d>zz", opts)
-- Paste over
keymap.set("x", "p", '"_dP', opts)

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
keymap.set("i", "jj", "<cmd>noh<cr><ESC>", opts)
keymap.set("i", "kk", "<cmd>noh<cr><ESC>", opts)
keymap.set("i", "kj", "<cmd>noh<cr><ESC>", opts)
keymap.set("n", "0", "^", opts)

-- Move to window using the <ctrl> hjkl keys
keymap.set("n", "<C-h>", "<C-w>h", { desc = "Go to left window", noremap = true, silent = true })
keymap.set("n", "<C-j>", "<C-w>j", { desc = "Go to lower window", noremap = true, silent = true })
keymap.set("n", "<C-k>", "<C-w>k", { desc = "Go to upper window", noremap = true, silent = true })
keymap.set("n", "<C-l>", "<C-w>l", { desc = "Go to right window", noremap = true, silent = true })

-- better indenting
keymap.set("v", ">", ">gv", opts)
keymap.set("v", "<", "<gv", opts)

-- Clear search with <esc>
keymap.set({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", opts)

-- search word under cursor
keymap.set({ "n", "x" }, "gw", "*N", { desc = "Search word under cursor", noremap = true, silent = true })

keymap.set(
  { "n", "x" },
  "fw",
  live_grep_args_shortcuts.grep_word_under_cursor,
  { desc = "Find Word in project under cursor", noremap = true, silent = true }
)

-- Move between buffers
keymap.set("n", "<S-h>", ":bprevious<cr>", { desc = "Prev buffer", noremap = true, silent = true })
keymap.set("n", "<S-l>", ":bnext<cr>", { desc = "Next buffer", noremap = true, silent = true })

vim.api.nvim_set_keymap("n", "<silent><c-t>", '<Cmd>exe v:count1 . "ToggleTerm"<CR>', { silent = true })
vim.api.nvim_set_keymap("i", "<silent><c-t>", '<Esc><Cmd>exe v:count1 . "ToggleTerm"<CR>', { silent = true })

-- Floating Terminal
-- keymap.set("n", "<C-t>", "<cmd>Lspsaga term_toggle<CR> ", { desc = "Terminal toggle", noremap = true, silent = true })

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
