local cybu_ok, cybu = pcall(require, "cybu")
if not cybu_ok then
	return
end

cybu.setup({})
