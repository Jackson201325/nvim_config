local status_ok, indent_scope = pcall(require, "mini.indentscope")
if not status_ok then
	print("indect scopt not ok")
	return
end

indent_scope.setup({})

-- local status_map_ok, map = pcall(require, "mini.map")
-- if not status_map_ok then
-- 	print("map not ok")
-- 	return
-- end
--
-- map.setup({})
