-- dap-repl specific settings

local dap_repl = vim.api.nvim_create_augroup("DapRepl", { clear = true })
vim.api.nvim_create_autocmd("WinEnter", {
  callback = function()
    if vim.bo.filetype == "dap-repl" then
      vim.cmd.startinsert()
    end
  end,
  group = dap_repl,
  pattern = "*",
  desc = "Start in insert mode in dap-repl buffers",
})

vim.keymap.set("i", "<c-p>", function()
  require("dap.repl").on_up()
end, { buf = 0, desc = "Previous command in DAP REPL history" })

vim.keymap.set("i", "<c-n>", function()
  require("dap.repl").on_down()
end, { buf = 0, desc = "Next command in DAP REPL history" })
