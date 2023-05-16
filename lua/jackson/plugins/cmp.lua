local cmp_status_ok, cmp = pcall(require, "cmp")
if not cmp_status_ok then
	print("Cmp status not ok")
	return
end

local snip_status_ok, luasnip = pcall(require, "luasnip")
if not snip_status_ok then
	print("luasnip status not ok")
	return
end

local lsp_kind_status_ok, lspkind = pcall(require, "lspkind")
if not lsp_kind_status_ok then
	print("LSPKIND status not ok")
	return
end

require("luasnip/loaders/from_vscode").lazy_load()

cmp.setup({
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
			-- vim.fn["UltiSnips#Anon"](args.body)
			-- vim.fn["vsnip#anonymous"](args.body)
		end,
	},
	requires = {
		{ "roobert/tailwindcss-colorizer-cmp.nvim", config = true },
	},
	mapping = {
		-- ["<CR>"] = cmp.mapping.confirm({ select = false }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
		["<CR>"] = cmp.mapping({
			i = function(fallback)
				if cmp.visible() and cmp.get_active_entry() then
					cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
					-- cmp.mapping.confirm({ select = true })
				else
					fallback()
				end
			end,
			s = cmp.mapping.confirm({ select = true }),
			c = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
		}),
		["<Down>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
		["<Up>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
	},
	sorting = {
		priority_weight = 2,
		comparators = {
			-- require("copilot_cmp.comparators").prioritize,
			-- Below is the default comparitor list and order for nvim-cmp
			cmp.config.compare.offset,
			-- cmp.config.compare.scopes, --this is commented in nvim-cmp too
			cmp.config.compare.exact,
			cmp.config.compare.score,
			cmp.config.compare.recently_used,
			cmp.config.compare.locality,
			cmp.config.compare.kind,
			cmp.config.compare.sort_text,
			cmp.config.compare.length,
			cmp.config.compare.order,
		},
	},
	formatting = {
		fields = { "kind", "abbr", "menu" },
		format = function(entry, vim_item)
			vim_item.kind = lspkind.presets.default[vim_item.kind]
			vim_item.menu = ({
				copilot = "[Copilot]",
				luasnip = "[LuaSnip]",
				nvim_lsp = "[LSP]",
				nvim_lua = "[LUA]",
				buffer = "[Buffer]",
				path = "[Path]",
				cmdline = "[CmdLine]",
				-- ultisnips = "[UltiSnips]",
				-- vsnip = "[VSnip]",
			})[entry.source.name]
			return vim_item
		end,
	},
	sources = {
		{ name = "copilot" },
		{ name = "nvim_lsp" },
		{ name = "luasnip", keyword_length = 1 },
		{ name = "nvim_lua", keyword_length = 2 },
		{ name = "path", keyword_length = 2 },
		{ name = "buffer", keyword_length = 2 },
		-- { name = "cmdline" },
		-- { name = "vsnip" },
		-- { name = "ultisnips" },
	},
	confirm_opts = {
		behavior = cmp.ConfirmBehavior.Replace,
		select = false,
	},
	window = {
		completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered(),
	},
	experimental = {
		ghost_text = true,
	},
})
