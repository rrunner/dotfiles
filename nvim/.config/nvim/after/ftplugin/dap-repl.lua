-- dap-repl specific settings
vim.keymap.set("i", "<c-p>", function()
  local exists, blink = pcall(require, "blink.cmp")
  if exists and blink.is_menu_visible() then
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<c-p>", true, false, true), "i", false)
    return
  end
  require("dap.repl").on_up()
end, { buf = 0, desc = "Previous command in DAP REPL history (next/prev in blink completion menu)" })

vim.keymap.set("i", "<c-n>", function()
  local exists, blink = pcall(require, "blink.cmp")
  if exists and blink.is_menu_visible() then
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<c-n>", true, false, true), "i", false)
    return
  end
  require("dap.repl").on_down()
end, { buf = 0, desc = "Next command in DAP REPL history (next/prev in blink completion menu)" })
