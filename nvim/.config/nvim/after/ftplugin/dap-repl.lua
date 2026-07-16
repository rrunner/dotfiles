-- dap-repl specific settings

vim.keymap.set("i", "<c-p>", function()
  require("dap.repl").on_up()
end, { buf = 0, desc = "Previous command in DAP REPL history" })

vim.keymap.set("i", "<c-n>", function()
  require("dap.repl").on_down()
end, { buf = 0, desc = "Next command in DAP REPL history" })
