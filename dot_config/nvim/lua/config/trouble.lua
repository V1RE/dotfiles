local trouble_ok, trouble = pcall(require, "trouble")
if not trouble_ok then
	return
end

trouble.setup({
	height = 4,
})
