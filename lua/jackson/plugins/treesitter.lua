local status_ok, configs = pcall(require, "nvim-treesitter.configs")
if not status_ok then
	print("nvim-treesitter not working")
	return
end

configs.setup({
	ensure_installed = {
		"bash",
		"c",
		"dockerfile",
		"vim",
		"javascript",
		"json",
		"lua",
		"sql",
		"python",
		"typescript",
		"ruby",
		"rust",
		"tsx",
		"css",
		"rust",
		"java",
		"yaml",
		"gitignore",
		"markdown",
		"markdown_inline",
	}, -- one of "all" or a list of languages
	ignore_install = { "phpdoc" }, -- List of parsers to ignore installing
	highlight = {
		enable = true, -- false will disable the whole extension
		disable = { "css" }, -- list of language that will be disabled
		additional_vim_regex_highlighting = true,
	},
	autopairs = {
		enable = true,
	},
	autotag = {
		enable = true,
	},
	indent = { enable = true, disable = { "python" } },
})
