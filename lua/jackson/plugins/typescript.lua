local typescript_status_ok, typescript = pcall(require, "typescript")
if not typescript_status_ok then
	print("typescript_status_ok not ok")
	return
end

typescript.setup({})
