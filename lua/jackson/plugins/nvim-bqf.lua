local fn = vim.fn
local status_ok, bfq = pcall(require, "bqf")

if not status_ok then
	print("BFQ scope not ok")
	return
end

bfq.setup({
	auto_enable = true,
	auto_resize_height = true,
	preview = {
		win_height = 12,
		win_vheight = 12,
		delay_syntax = 80,
		border = { "┏", "━", "┓", "┃", "┛", "━", "┗", "┃" },
		show_title = false,
		should_preview_cb = function(bufnr, qwinid)
			local ret = true
			local bufname = vim.api.nvim_buf_get_name(bufnr)
			local fsize = vim.fn.getfsize(bufname)
			if fsize > 100 * 1024 then
				-- skip file size greater than 100k
				ret = false
			elseif bufname:match("^fugitive://") then
				-- skip fugitive buffer
				ret = false
			end
			return ret
		end,
	},
	filter = {
		fzf = {
			extra_opts = { "--bind", "ctrl-o:toggle-all", "--delimiter", "│" },
		},
	},
})
