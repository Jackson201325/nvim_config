-- -- bundle exec solargraph stdio if Gemfile contains solargraph
-- vim.list_extend(vim.lsp.automatic_configuration.skipped_servers, { "solargraph" })

local solargraph_cmd = function()
	local ret_code = nil
	local jid = vim.fn.jobstart("cat Gemfile | grep solargraph", {
		on_exit = function(_, data)
			ret_code = data
		end,
	})
	vim.fn.jobwait({ jid }, 5000)
	if ret_code == 0 then
		return { "bundle", "exec", "solargraph", "stdio" }
	end
	return { "solargraph", "stdio" }
end

print(solargraph_cmd())

return {
	cmd = solargraph_cmd(),
	filetypes = { "ruby" },
	settings = {
		solargraph = {
			-- completion = true,
			-- codeAction = true,
			definition = true,
			hover = true,
			symbols = true,
			references = true,
			formatting = false,
			-- rename = true,
		},
	},
}
