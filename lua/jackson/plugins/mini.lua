local status_ok, indent_scope = pcall(require, "mini.indentscope")
if not status_ok then
	print("indect scopt not ok")
	return
end

indent_scope.setup({})

