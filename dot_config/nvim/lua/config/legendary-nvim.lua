local status_ok, legendary = pcall(require, "legendary")
if not status_ok then
	return
end

legendary.setup()
