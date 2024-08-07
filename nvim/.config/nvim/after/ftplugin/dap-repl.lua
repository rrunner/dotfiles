-- dap-repl specific settings
local function add_line(line)
  local lnum = vim.fn.line("$")
  line = string.gsub(line, "\n", "")
  vim.api.nvim_buf_set_lines(0, lnum - 1, lnum, true, { "dap> " .. line })
end

-- use p to paste into dap-repl buffer
vim.keymap.set("n", "p", function()
  add_line(vim.fn.getreg('"'))
end, { buffer = 0 })
