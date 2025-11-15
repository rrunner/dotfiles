local M = {}
_G.icons = M

-- default kinds (from Snacks markdown documentation originally)
M.kinds = {
  Array = "",
  Boolean = "󰨙 ",
  Class = " ",
  Collapsed = " ",
  Color = " ",
  Constant = "󰏿 ",
  Constructor = " ",
  Copilot = " ",
  Enum = " ",
  EnumMember = " ",
  Event = " ",
  Field = " ",
  File = " ",
  Folder = " ",
  Function = "󰊕 ",
  Interface = " ",
  Key = " ",
  Keyword = " ",
  Method = "󰡱 ",
  Module = " ",
  Namespace = "󰦮 ",
  Null = " ",
  Number = "󰎠 ",
  Object = " ",
  Operator = " ",
  Package = " ",
  Parameter = " ",
  Property = " ",
  Reference = " ",
  Snippet = "󱄽 ",
  StaticMethod = "󰡱 ",
  String = " ",
  Struct = "󰆼 ",
  Text = " ",
  TypeParameter = " ",
  Unit = " ",
  Unknown = " ",
  Value = "󰀫 ",
  Variable = "󰫧 ",
}

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
  deleted = "-",
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
  commit = "󰜘",
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

M.extra = {
  python_no_color = "",
}

return M
