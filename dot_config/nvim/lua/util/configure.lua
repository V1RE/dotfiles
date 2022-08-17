---@param modname string
---@return unknown
function _G.configure(modname)
  return function()
    require(modname)
  end
end
