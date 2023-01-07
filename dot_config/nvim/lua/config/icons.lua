local M = {
  Add = " ",
  Array = " ",
  ArrowDown = " ",
  ArrowLeft = " ",
  ArrowRight = " ",
  ArrowUp = " ",
  BigCircle = " ",
  BigUnfilledCircle = " ",
  BookMark = " ",
  Boolean = " ",
  Branch = " ",
  Buffer = " ",
  Bug = " ",
  Calendar = " ",
  Check = " ",
  ChevronDown = " ",
  ChevronLeft = " ",
  ChevronRight = " ",
  ChevronUp = " ",
  Circle = " ",
  Class = " ",
  Close = " ",
  ClosedFolder = " ",
  CloseAll = " ",
  Code = " ",
  Collapsed = " ",
  Color = " ",
  Comment = " ",
  Constant = " ",
  Constructor = " ",
  Copilot = " ",
  Create = " ",
  Dashboard = " ",
  Diff = " ",
  Enum = " ",
  EnumMember = " ",
  Error = " ",
  Event = " ",
  Field = " ",
  File = " ",
  Fire = " ",
  Folder = " ",
  Function = " ",
  Gear = " ",
  Goto = " ",
  Hint = " ",
  History = " ",
  Ignore = " ",
  Information = " ",
  Interface = " ",
  Key = " ",
  Keyword = " ",
  Lazy = "鈴",
  Lightbulb = " ",
  List = " ",
  Lock = " ",
  Menu = " ",
  Method = " ",
  Misc = " ",
  Mod = " ",
  Module = " ",
  Namespace = " ",
  NewFile = " ",
  NoHighlight = " ",
  Note = " ",
  Null = " ",
  Number = " ",
  NvimTree = " ",
  Object = " ",
  OpenFolder = " ",
  Operator = " ",
  Package = " ",
  Pencil = " ",
  Project = " ",
  Property = " ",
  Question = " ",
  Reference = " ",
  Remove = " ",
  Rename = " ",
  Repo = " ",
  Robot = " ",
  Rocket = " ",
  Save = " ",
  Search = " ",
  SearchCode = " ",
  SignIn = " ",
  SignOut = " ",
  Snippet = " ",
  Squirrel = " ",
  String = " ",
  Struct = " ",
  SymlinkFile = " ",
  SymlinkFolder = " ",
  Table = " ",
  Tag = " ",
  Telescope = " ",
  Terminal = " ",
  Text = " ",
  TypeParameter = " ",
  Unit = " ",
  Untracked = " ",
  Value = " ",
  Variable = " ",
  Warning = " ",
  Watch = " ",
  Window = " ",
}

local unspaced = {}

for name, icon in pairs(M) do
  unspaced[name] = icon:sub(1, -2)
end

M.unspaced = unspaced

return M
