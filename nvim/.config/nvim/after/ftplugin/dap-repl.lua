-- dap-repl specific settings

-- use p to paste into dap-repl buffer
local function add_line(line)
  local lnum = vim.fn.line("$")
  line = string.gsub(line, "\n", "")
  vim.api.nvim_buf_set_lines(0, lnum - 1, lnum, true, { "dap> " .. line })
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("$a", true, true, true), "n", true)
end

vim.keymap.set("n", "p", function()
  add_line(vim.fn.getreg('"'))
end, { buffer = 0 })

vim.keymap.set(
  "i",
  "<cr>",
  "<cr><esc>",
  { buffer = 0, noremap = true, silent = true, desc = "Return to normal mode after executing in dap-repl buffer" }
)
