local status_ok, hlslenns = pcall(require, "hlslens")
if not status_ok then
	print("Hlslens not ok")
	return
end

hlslenns.setup()
