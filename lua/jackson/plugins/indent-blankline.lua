local status_ok, indent_blankline = pcall(require, "indent_blankline")
if not status_ok then
	print("indent_blankline not ok")
	return
end

indent_blankline.setup({
	show_end_of_line = true,
})
