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

local has_words_before = function()
  unpack = unpack or table.unpack
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
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
    ["<C-k>"] = cmp.mapping({
      i = function()
        if cmp.visible() then
          cmp.abort()
        else
          cmp.complete()
        end
      end,
    }),
    -- ["<CR>"] = cmp.mapping.confirm({
    -- 	select = true,
    -- }),
    ["<Down>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
    ["<Up>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true })
        -- cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert })
        -- cmp.select_next_item()
        -- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
        -- they way you will only jump inside the snippet region
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
      require("copilot_cmp.comparators").prioritize,
      -- Below is the default comparitor list and order for nvim-cmp
      cmp.config.compare.offset,
      cmp.config.compare.scopes, --this is commented in nvim-cmp too
      cmp.config.compare.exact,
      cmp.config.compare.score,
      cmp.config.compare.kind,
      cmp.config.compare.sort_text,
      cmp.config.compare.length,
      cmp.config.compare.order,
      -- cmp.config.compare.recently_used,
      -- cmp.config.compare.locality,
    },
  },
  formatting = {
    fields = { "kind", "abbr", "menu" },
    format = function(entry, vim_item)
      vim_item.kind = lspkind.presets.default[vim_item.kind]
      vim_item.menu = ({
        copilot = "[Copilot]",
        nvim_lsp = "[LSP]",
        luasnip = "[LuaSnip]",
        nvim_lua = "[LUA]",
        buffer = "[Buffer]",
        path = "[Path]",
        cmdline = "[CmdLine]",
        -- crates = "[Crates]",
        -- ultisnips = "[UltiSnips]",
        -- vsnip = "[VSnip]",
      })[entry.source.name]
      return vim_item
    end,
  },
  sources = {
    { name = "nvim_lua", keyword_length = 1 },
    { name = "nvim_lsp", keyword_length = 1 },
    { name = "luasnip",  keyword_length = 1 },
    { name = "copilot",  keyword_length = 1 },
    { name = "path",     keyword_length = 2 },
    { name = "buffer",   keyword_length = 2 },
    -- { name = "crates", keyword_length = 1 },
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
})
