local status_map_ok, persistance = pcall(require, "persistance")
if not status_map_ok then
	print("Persistence not ok")
	return
end

persistance.setup({
	event = "BufReadPre",
	opts = { options = { "buffers", "curdir", "tabpages", "winsize", "help", "globals" } },
    keys = {
      { "<leader>qs", function() require("persistence").load() end, desc = "Restore Session" },
      { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Restore Last Session" },
      { "<leader>qd", function() require("persistence").stop() end, desc = "Don't Save Current Session" },
    },
})
