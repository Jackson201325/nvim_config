local status_ok, transparent = pcall(require, "transparent")
if not status_ok then
	return
end

transparent.setup({
	groups = { -- table: default groups
		"Normal",
		"NormalNC",
		"Comment",
		"Constant",
		"CursorLine",
		"CursorLineNR",
		"NormalFloat",
		"Special",
		"Identifier",
		"Statement",
		"PreProc",
		"Type",
		"Underlined",
		"Todo",
		"String",
		"Function",
		"Conditional",
		"Repeat",
		"Operator",
		"Structure",
		"LspSagaBorderTitle",
		"LspSagaFinderSelection",
		"LspSagaCodeActionBorder",
		"FloatBorder",
		"FloatBorderNC",
		"Float",
		"LspSagaHoverBorder",
		"LspSagaRenameBorder",
		"BqfPreviewBorder",
		"BqfPreviewTitle",
		"BqfPreviewThumb",
		"LspSagaCodeActionTitle",
		"LineNr",
		"NonText",
		"SignColumn",
		"CursorLineNr",
		"EndOfBuffer",
	},
	extra_groups = {
		"NormalFloat",
		"BufferLineTabClose",
		"BufferlineBufferSelected",
		"BufferLineFill",
		"BufferLineBackground",
		"BufferLineSeparator",
		"BufferLineIndicatorSelected",
		"CursorLine",
		"CursorColumn",
		"FloatBorder",
		"FloatBorderNC",
		"Float",
		"QuickfixLine",
		"StatusLine",
		"StatusLineNC",
		"UfoFoldedBg",
		"UfoFoldedFg",
		"UfoPreviewSbar",
		"UfoPreviewWinbar",
		"LspSagaBorderTitle",
		"LspSagaFinderSelection",
		"LspSagaCodeActionBorder",
		"LspSagaHoverBorder",
		"LspSagaRenameBorder",
		"BqfPreviewBorder",
		"BqfPreviewTitle",
		"BqfPreviewThumb",
		"LspSagaCodeActionTitle",
		"UfoCursorFoldedLine",
		"UfoPreviewCursorLine",
		"NeoTreeNormal",
		"LspSagaFinderSelection",
		"LspSagaHoverBorder",
		"LspSagaPreviewBorder",
		"TelescopePromptBorder",
		"TelescopeNormal",
		"ToolbarLine",
		"WhichKey",
		"WhichKeyFloat",
	}, -- table: additional groups that should be cleared
	exclude_groups = {}, -- table: groups you don't want to clear
})
