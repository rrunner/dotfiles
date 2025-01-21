local M = {}
_G.icons = M

local kinds = {
  Array = { icon = "", hl = "Type" },
  Boolean = { icon = "󰨙 ", hl = "Boolean" },
  Class = { icon = " ", hl = "Include" },
  Collapsed = { icon = " ", hl = "" },
  Color = { icon = " ", hl = "" },
  Constant = { icon = "󰏿 ", hl = "Constant" },
  Constructor = { icon = " ", hl = "@constructor" },
  Copilot = { icon = " ", hl = "" },
  Enum = { icon = " ", hl = "@number" },
  EnumMember = { icon = " ", hl = "Number" },
  Event = { icon = " ", hl = "Constant" },
  Field = { icon = " ", hl = "@field" },
  File = { icon = " ", hl = "Tag" },
  Folder = { icon = " ", hl = "" },
  Function = { icon = "󰊕 ", hl = "Function" },
  Interface = { icon = " ", hl = "Type" },
  Key = { icon = " ", hl = "" },
  Keyword = { icon = " ", hl = "" },
  Method = { icon = "󰡱 ", hl = "Function" },
  Module = { icon = " ", hl = "Exception" },
  Namespace = { icon = "󰦮 ", hl = "Include" },
  Null = { icon = " ", hl = "Constant" },
  Number = { icon = "󰎠 ", hl = "Number" },
  Object = { icon = " ", hl = "Type" },
  Operator = { icon = " ", hl = "Operator" },
  Package = { icon = " ", hl = "Label" },
  Parameter = { icon = " ", hl = "@parameter" },
  Property = { icon = " ", hl = "@property" },
  Reference = { icon = " ", hl = "" },
  Snippet = { icon = "󱄽 ", hl = "" },
  StaticMethod = { icon = "󰡱 ", hl = "Function" },
  String = { icon = " ", hl = "String" },
  Struct = { icon = "󰆼 ", hl = "Type" },
  Text = { icon = " ", hl = "" },
  TypeParameter = { icon = " ", hl = "Type" },
  Unit = { icon = " ", hl = "" },
  Unknown = { icon = " ", hl = "" },
  Value = { icon = "󰀫 ", hl = "" },
  Variable = { icon = "󰫧 ", hl = "@variable" },
}

local kinds_cmp = {}
for kind_type, icon_hl in pairs(kinds) do
  kinds_cmp[kind_type] = icon_hl.icon
end

-- kinds to be used in cmp, aerial, snacks etc.
M._kinds_cmp = kinds_cmp

-- LSP diagnosis signs
M.diagnosis = {
  error = "",
  warn = "",
  info = "",
  hint = "",
}

M.dap = {
  breakpoint = "",
  logpoint = "",
  condition = "",
  rejected = "",
  stopped = "",
}

M.bullets = { "", "", "󰨓", "󰨔", "-", "+" }

M.three_dots = "󰇘"

M.selected = " "

M.git_icons = {
  added = "+",
  deleted = "_",
  changed = "~",
  modified = "~",
  renamed = "r",
  copied = "c",
  unstaged = "u",
  staged = "s",
  untracked = "?",
  ignored = "i",
  conflict = "",
  unmerged = "",
}

M.snacks_notifier = {
  error = " ",
  warn = " ",
  info = " ",
  debug = " ",
  trace = " ",
}

M.chars = {
  foldopen = "",
  foldclose = "",
  diff = "╱",
}

return M
