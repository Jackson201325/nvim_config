local setup, lspsaga = pcall(require, "lspsaga")
if not setup then
	return
end

lspsaga.setup({
	opt = true,
	branch = "main",
	event = "LspAttach",
	config = function()
		require("lspsaga").setup({})
	end,
	requires = {
		{ "nvim-tree/nvim-web-devicons" },
		--Please make sure you install markdown and markdown_inline parser
		{ "nvim-treesitter/nvim-treesitter" },
	},
})
