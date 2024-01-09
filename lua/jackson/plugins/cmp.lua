local cmp_status_ok, cmp = pcall(require, "cmp")
if not cmp_status_ok then
	return
end

local snip_status_ok, luasnip = pcall(require, "luasnip")
if not snip_status_ok then
	return
end

local lsp_kind_status_ok, lspkind = pcall(require, "lspkind")
if not lsp_kind_status_ok then
	return
end

local has_words_before = function()
	unpack = unpack or table.unpack
	local line, col = unpack(vim.api.nvim_win_get_cursor(0))
	return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local compare = require("cmp.config.compare")
require("luasnip/loaders/from_vscode").lazy_load()

cmp.setup({
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
	requires = {
		{ "roobert/tailwindcss-colorizer-cmp.nvim", config = true },
	},
	mapping = {
		["<C-u>"] = cmp.mapping.scroll_docs(-4),
		["<C-d>"] = cmp.mapping.scroll_docs(4),
		["<C-k>"] = cmp.mapping({
			i = function()
				if cmp.visible() then
					cmp.abort()
				else
					cmp.complete()
				end
			end,
		}),
		["<C-n>"] = cmp.mapping(cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }), { "i" }),
		["<C-p>"] = cmp.mapping(cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }), { "i" }),

		["<Down>"] = cmp.mapping(cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }), { "i" }),
		["<Up>"] = cmp.mapping(cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }), { "i" }),

		["<Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.confirm({ behavior = cmp.ConfirmBehavior.Insert, select = true })
			elseif luasnip.expand_or_jumpable() then
				luasnip.expand_or_jump()
			elseif has_words_before() then
				cmp.complete()
			else
				fallback()
			end
		end, { "i", "s" }),

		["<S-Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif luasnip.jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end, { "i", "s" }),
	},
	sorting = {
		priority_weight = 2,
		comparators = {

			-- Below is the default comparitor list and order for nvim-cmp
			compare.exact,
			compare.offset,
			compare.score,
			compare.recently_used,
			compare.kind,
			compare.sort_text,
			compare.length,
			compare.order,
		},
	},
	matching = {
		disallow_fullfuzzy_matching = true,
		disallow_fuzzy_matching = true,
		disallow_partial_fuzzy_matching = true,
		disallow_partial_matching = true,
		disallow_prefix_unmatching = true,
	},
	formatting = {
		expandable_indicator = true,
		fields = { "abbr", "kind", "menu" },
		format = function(entry, vim_item)
			vim_item.menu = lspkind.presets.default[vim_item.kind]
			return vim_item
		end,
	},
	sources = {
		{ name = "nvim_lsp", keyword_length = 1, priority = 1 },
		{ name = "copilot", keyword_length = 1, priority = 1 },
		{ name = "luasnip", keyword_length = 1, priority = 3 },
		{ name = "nvim_lua", keyword_length = 2, priority = 3 },
		{ name = "path", keyword_length = 2 },
		{ name = "buffer", keyword_length = 2 },
	},
	confirm_opts = {
		behavior = cmp.ConfirmBehavior.Insert,
		select = false,
	},
	window = {
		completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered(),
	},
	experimental = {
		ghost_text = false,
	},
})
