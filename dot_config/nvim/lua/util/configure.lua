---@param modname string
function _G.configure(modname)
  return function()
    require(modname)
  end
end
