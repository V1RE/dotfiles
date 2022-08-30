local incline_ok, incline = pcall(require, "incline")

if not incline_ok then
	return
end

incline.setup({})
