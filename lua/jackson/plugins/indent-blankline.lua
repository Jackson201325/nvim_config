local status_ok, indent_blankline = pcall(require, "indent_blankline")
if not status_ok then
	print("indent_blankline not ok")
	return
end

indent_blankline.setup({
	context_char = "│",
	filetype_exclude = {
		"help",
		"alpha",
		"dashboard",
		"neo-tree",
		"lspsaga",
		"Trouble",
		"lazy",
		"mason",
		"notify",
		"toggleterm",
		"lazyterm",
	},
	show_trailing_blankline_indent = false,
	show_current_context = false,
})
