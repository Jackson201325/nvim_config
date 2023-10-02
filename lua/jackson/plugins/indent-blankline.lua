local status_ok, indent_blankline = pcall(require, "ibl")
if not status_ok then
	print("indent_blankline not ok")
	return
end

indent_blankline.setup({
	exclude = {
		filetypes = {
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
	},
	scope = {
    enabled = false,
    show_end = false,
    show_start = false,
  },
  indent = { char = "│" },
})
