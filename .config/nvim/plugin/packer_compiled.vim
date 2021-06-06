" Automatically generated packer.nvim plugin loader code

if !has('nvim-0.5')
  echohl WarningMsg
  echom "Invalid Neovim version for packer.nvim!"
  echohl None
  finish
endif

packadd packer.nvim

try

lua << END
  local time
  local profile_info
  local should_profile = false
  if should_profile then
    local hrtime = vim.loop.hrtime
    profile_info = {}
    time = function(chunk, start)
      if start then
        profile_info[chunk] = hrtime()
      else
        profile_info[chunk] = (hrtime() - profile_info[chunk]) / 1e6
      end
    end
  else
    time = function(chunk, start) end
  end
  
local function save_profiles(threshold)
  local sorted_times = {}
  for chunk_name, time_taken in pairs(profile_info) do
    sorted_times[#sorted_times + 1] = {chunk_name, time_taken}
  end
  table.sort(sorted_times, function(a, b) return a[2] > b[2] end)
  local results = {}
  for i, elem in ipairs(sorted_times) do
    if not threshold or threshold and elem[2] > threshold then
      results[i] = elem[1] .. ' took ' .. elem[2] .. 'ms'
    end
  end

  _G._packer = _G._packer or {}
  _G._packer.profile_output = results
end

time("Luarocks path setup", true)
local package_path_str = "/Users/nielsmentink/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?.lua;/Users/nielsmentink/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?/init.lua;/Users/nielsmentink/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?.lua;/Users/nielsmentink/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?/init.lua"
local install_cpath_pattern = "/Users/nielsmentink/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/lua/5.1/?.so"
if not string.find(package.path, package_path_str, 1, true) then
  package.path = package.path .. ';' .. package_path_str
end

if not string.find(package.cpath, install_cpath_pattern, 1, true) then
  package.cpath = package.cpath .. ';' .. install_cpath_pattern
end

time("Luarocks path setup", false)
time("try_loadstring definition", true)
local function try_loadstring(s, component, name)
  local success, result = pcall(loadstring(s))
  if not success then
    print('Error running ' .. component .. ' for ' .. name)
    error(result)
  end
  return result
end

time("try_loadstring definition", false)
time("Defining packer_plugins", true)
_G.packer_plugins = {
  ["auto-pairs"] = {
    loaded = true,
    path = "/Users/nielsmentink/.local/share/nvim/site/pack/packer/start/auto-pairs"
  },
  ["barbar.nvim"] = {
    loaded = true,
    path = "/Users/nielsmentink/.local/share/nvim/site/pack/packer/start/barbar.nvim"
  },
  ["coc.nvim"] = {
    loaded = true,
    path = "/Users/nielsmentink/.local/share/nvim/site/pack/packer/start/coc.nvim"
  },
  ["doom-one.vim"] = {
    loaded = true,
    path = "/Users/nielsmentink/.local/share/nvim/site/pack/packer/start/doom-one.vim"
  },
  ["emmet-vim"] = {
    loaded = true,
    path = "/Users/nielsmentink/.local/share/nvim/site/pack/packer/start/emmet-vim"
  },
  ["friendly-snippets"] = {
    loaded = true,
    path = "/Users/nielsmentink/.local/share/nvim/site/pack/packer/start/friendly-snippets"
  },
  ["galaxyline.nvim"] = {
    loaded = true,
    path = "/Users/nielsmentink/.local/share/nvim/site/pack/packer/start/galaxyline.nvim"
  },
  ["git-blame.nvim"] = {
    loaded = true,
    path = "/Users/nielsmentink/.local/share/nvim/site/pack/packer/start/git-blame.nvim"
  },
  ["gitsigns.nvim"] = {
    loaded = true,
    path = "/Users/nielsmentink/.local/share/nvim/site/pack/packer/start/gitsigns.nvim"
  },
  ["hop.nvim"] = {
    loaded = true,
    path = "/Users/nielsmentink/.local/share/nvim/site/pack/packer/start/hop.nvim"
  },
  ["lazygit.nvim"] = {
    loaded = true,
    path = "/Users/nielsmentink/.local/share/nvim/site/pack/packer/start/lazygit.nvim"
  },
  ["lsp_signature.nvim"] = {
    loaded = true,
    path = "/Users/nielsmentink/.local/share/nvim/site/pack/packer/start/lsp_signature.nvim"
  },
  ["lspkind-nvim"] = {
    loaded = true,
    path = "/Users/nielsmentink/.local/share/nvim/site/pack/packer/start/lspkind-nvim"
  },
  ["lspsaga.nvim"] = {
    loaded = true,
    path = "/Users/nielsmentink/.local/share/nvim/site/pack/packer/start/lspsaga.nvim"
  },
  ["markdown-preview.nvim"] = {
    loaded = true,
    path = "/Users/nielsmentink/.local/share/nvim/site/pack/packer/start/markdown-preview.nvim"
  },
  ["nvcode-color-schemes.vim"] = {
    loaded = true,
    path = "/Users/nielsmentink/.local/share/nvim/site/pack/packer/start/nvcode-color-schemes.vim"
  },
  ["nvim-colorizer.lua"] = {
    loaded = true,
    path = "/Users/nielsmentink/.local/share/nvim/site/pack/packer/start/nvim-colorizer.lua"
  },
  ["nvim-lightbulb"] = {
    loaded = true,
    path = "/Users/nielsmentink/.local/share/nvim/site/pack/packer/start/nvim-lightbulb"
  },
  ["nvim-lspconfig"] = {
    loaded = true,
    path = "/Users/nielsmentink/.local/share/nvim/site/pack/packer/start/nvim-lspconfig"
  },
  ["nvim-lspinstall"] = {
    loaded = true,
    path = "/Users/nielsmentink/.local/share/nvim/site/pack/packer/start/nvim-lspinstall"
  },
  ["nvim-tree.lua"] = {
    loaded = true,
    path = "/Users/nielsmentink/.local/share/nvim/site/pack/packer/start/nvim-tree.lua"
  },
  ["nvim-treesitter"] = {
    loaded = true,
    path = "/Users/nielsmentink/.local/share/nvim/site/pack/packer/start/nvim-treesitter"
  },
  ["nvim-treesitter-refactor"] = {
    loaded = true,
    path = "/Users/nielsmentink/.local/share/nvim/site/pack/packer/start/nvim-treesitter-refactor"
  },
  ["nvim-ts-rainbow"] = {
    loaded = true,
    path = "/Users/nielsmentink/.local/share/nvim/site/pack/packer/start/nvim-ts-rainbow"
  },
  ["nvim-web-devicons"] = {
    loaded = true,
    path = "/Users/nielsmentink/.local/share/nvim/site/pack/packer/start/nvim-web-devicons"
  },
  ["nvim-whichkey-setup.lua"] = {
    loaded = true,
    path = "/Users/nielsmentink/.local/share/nvim/site/pack/packer/start/nvim-whichkey-setup.lua"
  },
  ["packer.nvim"] = {
    loaded = true,
    path = "/Users/nielsmentink/.local/share/nvim/site/pack/packer/start/packer.nvim"
  },
  phpactor = {
    loaded = true,
    path = "/Users/nielsmentink/.local/share/nvim/site/pack/packer/start/phpactor"
  },
  ["plenary.nvim"] = {
    loaded = true,
    path = "/Users/nielsmentink/.local/share/nvim/site/pack/packer/start/plenary.nvim"
  },
  ["popup.nvim"] = {
    loaded = true,
    path = "/Users/nielsmentink/.local/share/nvim/site/pack/packer/start/popup.nvim"
  },
  sonokai = {
    loaded = true,
    path = "/Users/nielsmentink/.local/share/nvim/site/pack/packer/start/sonokai"
  },
  ["telescope.nvim"] = {
    loaded = true,
    path = "/Users/nielsmentink/.local/share/nvim/site/pack/packer/start/telescope.nvim"
  },
  ["vim-commentary"] = {
    loaded = true,
    path = "/Users/nielsmentink/.local/share/nvim/site/pack/packer/start/vim-commentary"
  },
  ["vim-devicons"] = {
    loaded = true,
    path = "/Users/nielsmentink/.local/share/nvim/site/pack/packer/start/vim-devicons"
  },
  ["vim-floaterm"] = {
    loaded = true,
    path = "/Users/nielsmentink/.local/share/nvim/site/pack/packer/start/vim-floaterm"
  },
  ["vim-matchup"] = {
    loaded = true,
    path = "/Users/nielsmentink/.local/share/nvim/site/pack/packer/start/vim-matchup"
  },
  ["vim-phpfmt"] = {
    loaded = true,
    path = "/Users/nielsmentink/.local/share/nvim/site/pack/packer/start/vim-phpfmt"
  },
  ["vim-polyglot"] = {
    loaded = true,
    path = "/Users/nielsmentink/.local/share/nvim/site/pack/packer/start/vim-polyglot"
  },
  ["vim-surround"] = {
    loaded = true,
    path = "/Users/nielsmentink/.local/share/nvim/site/pack/packer/start/vim-surround"
  },
  ["vim-tmux-navigator"] = {
    loaded = true,
    path = "/Users/nielsmentink/.local/share/nvim/site/pack/packer/start/vim-tmux-navigator"
  },
  ["vim-wakatime"] = {
    loaded = true,
    path = "/Users/nielsmentink/.local/share/nvim/site/pack/packer/start/vim-wakatime"
  },
  ["vim-which-key"] = {
    loaded = true,
    path = "/Users/nielsmentink/.local/share/nvim/site/pack/packer/start/vim-which-key"
  },
  ["yats.vim"] = {
    loaded = true,
    path = "/Users/nielsmentink/.local/share/nvim/site/pack/packer/start/yats.vim"
  }
}

time("Defining packer_plugins", false)
if should_profile then save_profiles() end

END

catch
  echohl ErrorMsg
  echom "Error in packer_compiled: " .. v:exception
  echom "Please check your config for correctness"
  echohl None
endtry
