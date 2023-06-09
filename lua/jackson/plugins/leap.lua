local status_ok, leap = pcall(require, "leap")
if not status_ok then
	print("Leap not op")
	return
end

leap.setup({
	-- keys = {
	-- 	{ "s", mode = { "n", "x", "o" }, desc = "Leap forward to" },
	-- 	{ "S", mode = { "n", "x", "o" }, desc = "Leap backward to" },
	-- 	{ "gs", mode = { "n", "x", "o" }, desc = "Leap from windows" },
	-- },
	-- opts = function(_, opts)
	-- 	for k, v in pairs(opts) do
	-- 		leap.opts[k] = v
	-- 	end
	-- 	leap.add_default_mappings(true)
	-- 	vim.keymap.del({ "x", "o" }, "x")
	-- 	vim.keymap.del({ "x", "o" }, "X")
	-- end,
	-- max_phase_one_targets = nil
	highlight_unlabeled_phase_one_targets = false,
	max_highlighted_traversal_targets = 10,
	case_sensitive = false,
	equivalence_classes = { " \t\r\n" },
	substitute_chars = {},
	safe_labels = { "s", "f", "n", "u", "t" },
	labels = { "s", "f", "n", "j", "k" },
	special_keys = {
		repeat_search = "<enter>",
		next_phase_one_target = "<enter>",
		next_target = { "<enter>", ";" },
		prev_target = { "<tab>", "," },
		next_group = "<space>",
		prev_group = "<tab>",
		multi_accept = "<enter>",
		multi_revert = "<backspace>",
	},
})
