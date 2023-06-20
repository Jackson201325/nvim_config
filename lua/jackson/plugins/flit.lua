local status_ok, flit = pcall(require, "flit")
if not status_ok then
	return
end

flit.setup({
	keys = { f = "f", F = "F", t = "t", T = "T" },
	-- A string like "nv", "nvo", "o", etc.
	labeled_modes = "v",
	multiline = true,
	-- Like `leap`s similar argument (call-specific overrides).
	-- E.g.: opts = { equivalence_classes = {} }
	opts = {},
	-- keys = function()
	-- 	local ret = {}
	-- 	for _, key in ipairs({ "f", "F", "t", "T" }) do
	-- 		ret[#ret + 1] = { key, mode = { "n", "x", "o" }, desc = key }
	-- 	end
	-- 	return ret
	-- end,
})
