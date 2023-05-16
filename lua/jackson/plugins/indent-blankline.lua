local status_ok, indent_blankline = pcall(require, "indent_blankline")
if not status_ok then
	print("indent_blankline not ok")
	return
end

indent_blankline.setup({
	show_end_of_line = true,
	context_char = "│",
	filetype_exclude = { "help", "alpha", "dashboard", "neo-tree", "Trouble", "lazy", "mason" },
	show_trailing_blankline_indent = true,
	show_current_context = false,
})
