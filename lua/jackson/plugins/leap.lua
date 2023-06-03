local status_ok, leap = pcall(require, "leap")
if not status_ok then
	print("Leap not op")
	return
end

leap.setup({
	keys = {
		{ "s", mode = { "n", "x", "o" }, desc = "Leap forward to" },
		{ "S", mode = { "n", "x", "o" }, desc = "Leap backward to" },
		{ "gs", mode = { "n", "x", "o" }, desc = "Leap from windows" },
	},
	opts = function(_, opts)
		for k, v in pairs(opts) do
			leap.opts[k] = v
		end
		leap.add_default_mappings(true)
		vim.keymap.del({ "x", "o" }, "x")
		vim.keymap.del({ "x", "o" }, "X")
	end,
})
