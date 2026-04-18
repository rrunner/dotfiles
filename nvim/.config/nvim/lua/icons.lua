-- icons
local M = {}

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
  square = "󰨓",
}

M.dap = {
  breakpoint = " 󰯮",
  logpoint = " 󰰌",
  condition = " 󰯱",
  rejected = " 󰰞",
  stopped = " ",
}

M.test = {
  failed = "",
  notify = "󰚭",
  passed = "",
  running = "",
  running_animated = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" },
  skipped = "",
  test = "",
  unknown = "",
  watching = "",
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

-- LSP kind icons provided by mini.icons
M.lsp_mini_icons = function()
  local exists, mini_icons = pcall(require, "mini.icons")
  if not exists then
    return
  end

  local kind_icon_map = {}
  -- snacks perform lookup based on camel case, hence union below
  local all_kinds = Config.utils.unique_values(mini_icons.list("lsp"), vim.tbl_keys(M.kinds))
  for _, kind in ipairs(all_kinds) do
    local mini_icon, _, is_default = mini_icons.get("lsp", kind)
    if is_default then
      -- fallback when icon is not provided by mini.icons
      vim.notify("Icon for LSP kind " .. kind .. " is not provided by mini.icons", vim.log.levels.WARN)
      mini_icon = M.kinds[kind] or " "
    end
    kind_icon_map[kind] = mini_icon
  end
  return kind_icon_map or M.kinds
end

Config.icons = M
