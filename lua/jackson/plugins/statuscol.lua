local status_ok, status_col = pcall(require, "statuscol")
if not status_ok then
	return
end

local builtin = require("statuscol.builtin")

status_col.setup({
	setopt = true,
	relculright = true,
	segments = {
		{ text = { builtin.foldfunc } },
		{ text = { builtin.lnumfunc } },
		{ text = { "%s" } },
	},
})
