local status_ok, _ = pcall(require, "lspconfig")
if not status_ok then
	return
end

require("jackson.plugins.lsp.mason")
require("jackson.plugins.lsp.handler").setup()
require("jackson.plugins.lsp.null-ls")
