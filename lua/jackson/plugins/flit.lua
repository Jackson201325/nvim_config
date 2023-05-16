local status_ok_fit, flit = pcall(require, "flit")
if not status_ok_fit then
	return
end

flit.setup({
	keys = { f = "f", F = "F", t = "t", T = "T" },
	labeled_modes = "v",
	multiline = true,
	-- Like `leap`s similar argument (call-specific overrides).
	-- E.g.: opts = { equivalence_classes = {} }
	opts = {},
})
