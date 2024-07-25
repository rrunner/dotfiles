local M = {}
_G.icons = M

local kinds = {
  Text = { icon = "󰊄", hl = "" },
  Unit = { icon = "", hl = "" },
  Value = { icon = "󰎠", hl = "" },
  Keyword = { icon = "󰌋", hl = "" },
  Snippet = { icon = "", hl = "" },
  Color = { icon = "󰏘", hl = "" },
  Reference = { icon = "", hl = "" },
  Folder = { icon = "󰉋", hl = "" },
  Unknown = { icon = "", hl = "" },
  Root = { icon = "", hl = "NeoTreeRootName" },
  File = { icon = "󰈙", hl = "Tag" },
  Module = { icon = "", hl = "Exception" },
  Namespace = { icon = "󰌗", hl = "Include" },
  Package = { icon = "󰏖", hl = "Label" },
  Class = { icon = "󰌗", hl = "Include" },
  Method = { icon = "󰡱", hl = "Function" },
  Property = { icon = "󰆧", hl = "@property" },
  Field = { icon = "", hl = "@field" },
  Constructor = { icon = "", hl = "@constructor" },
  Enum = { icon = "󰒻", hl = "@number" },
  Interface = { icon = "", hl = "Type" },
  Function = { icon = "󰊕", hl = "Function" },
  Variable = { icon = "󰫧", hl = "@variable" },
  Constant = { icon = "", hl = "Constant" },
  String = { icon = "󱀍", hl = "String" },
  Number = { icon = "󰎠", hl = "Number" },
  Boolean = { icon = "", hl = "Boolean" },
  Array = { icon = "", hl = "Type" },
  Object = { icon = "󰅩", hl = "Type" },
  Key = { icon = "󰌋", hl = "" },
  Null = { icon = "󰟢", hl = "Constant" },
  EnumMember = { icon = "", hl = "Number" },
  Struct = { icon = "󰌗", hl = "Type" },
  Event = { icon = "", hl = "Constant" },
  Operator = { icon = "󰆕", hl = "Operator" },
  TypeParameter = { icon = "󰊄", hl = "Type" },
  TypeAlias = { icon = "", hl = "Type" },
  Parameter = { icon = "", hl = "@parameter" },
  StaticMethod = { icon = "󰡱", hl = "Function" },
  Macro = { icon = "", hl = "Macro" },
}

local kinds_cmp = {}
for kind_type, icon_hl in pairs(kinds) do
  kinds_cmp[kind_type] = icon_hl.icon
end

-- global kinds to be used in cmp, neotree, aerial etc.
M._kinds = kinds
M._kinds_cmp = kinds_cmp

-- LSP diagnosis signs
M.diagnosis = {
  error = "",
  warn = "",
  info = "",
  hint = "",
  -- error = "",
  -- warn = "",
  -- info = "",
  -- hint = "",
}

M.dap = {
  breakpoint = "󰬉",
  logpoint = "",
  stopped = "",
}

M.bullets = { "", "", "󰨓", "󰨔", "󰍴", "󰐕" }

M.three_dots = "󰇘"

return M
