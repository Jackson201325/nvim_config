local mark_status_ok, mark = pcall(require, "harpoon.mark")
local ui_status_ok, ui = pcall(require, "harpoon.ui")

if not mark_status_ok or not ui_status_ok then
  return
end
vim.keymap.set("n", "<C-g>", mark.add_file, { desc = "Add file to harpoon" })
vim.keymap.set("n", "<C-e>", ui.toggle_quick_menu, { desc = "Toggle harpoon menu" })
vim.keymap.set("n", "<C-f>", function()
  ui.nav_next()
end, { desc = "Navigate to next harpoon mark" })
vim.keymap.set("n", "<C-b>", function()
  ui.nav_prev()
end, { desc = "Navigate to previous harpoon mark" })

vim.keymap.set("n", "<leader>1", function()
  ui.nav_file(1)
end)
vim.keymap.set("n", "<leader>2", function()
  ui.nav_file(2)
end)
vim.keymap.set("n", "<leader>3", function()
  ui.nav_file(3)
end)
vim.keymap.set("n", "<leader>4", function()
  ui.nav_file(4)
end)
