local status_ok, copilot = pcall(require, "copilot")
if not status_ok then
	return
end

copilot.setup({
	cmd = "Copilot",
	build = ":Copilot auth",
	event = "VimEnter",
	config = function()
		vim.defer_fn(function()
			require("copilot").setup({
				panel = { enabled = false },
			})
		end, 100)
	end,
	suggestion = { enabled = false },
})
