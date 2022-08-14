local impatient_ok = pcall(require, "impatient")
if not impatient_ok then
  return
end

local impatient = require("impatient")
if not impatient then
  return
end

impatient.enable_profile()
