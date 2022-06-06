local fidget_ok, fidget = pcall(require, "fidget")
if not fidget_ok then
	return
end

fidget.setup({})
