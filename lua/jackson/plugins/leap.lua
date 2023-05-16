local status_ok, leap = pcall(require, "leap")
if not status_ok then
	print("Leap not ok")
	return
end

leap.setup({
	config = function()
		require("leap").set_default_keymaps()
	end,
})
