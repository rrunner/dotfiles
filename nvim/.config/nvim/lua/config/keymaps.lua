-- general key mappings
-- note: plugin specific key mappings are generally set in each plugin configuration respectively

vim.api.nvim_set_keymap(
  "x",
  "/",
  "<esc>/\\%V",
  { noremap = true, silent = false, desc = "Search only in visual selected text" }
)

vim.api.nvim_set_keymap("n", "U", "<c-r>", {
  noremap = true,
  silent = false,
  desc = "Redo",
})

vim.api.nvim_set_keymap("n", "<leader>DD", [[""dd]], {
  noremap = true,
  silent = false,
  desc = "Delete line but do not write to yank register",
})

-- note: use ":" to fetch visual selection to command-line mode in visual mode
vim.api.nvim_set_keymap("n", "<esc>", ":", {
  noremap = true,
  silent = false,
  desc = "Escape in normal mode to enter command-line mode",
})

vim.api.nvim_set_keymap("t", "<esc>", [[<c-\><c-n>]], {
  noremap = true,
  silent = true,
  desc = "Switch to normal mode from terminal mode",
})

vim.keymap.set("n", "<c-t>", function()
  pcall(vim.cmd, [[NoiceDismiss]])
  vim.cmd([[nohlsearch]])
end, { desc = "Remove search highlight and noice/notification pop-ups", noremap = true, silent = true })

-- vim.api.nvim_set_keymap("v", "J", ":m '>+1<cr>gv=gv", {
--   noremap = true,
--   silent = true,
--   desc = "Move text below in visual mode",
-- })
--
-- vim.api.nvim_set_keymap("v", "K", ":m '<-2<cr>gv=gv", {
--   noremap = true,
--   silent = true,
--   desc = "Move text above in visual mode",
-- })

vim.api.nvim_set_keymap("v", "<", "<gv", {
  noremap = true,
  silent = true,
  desc = "Reselect visual selection after de-indenting",
})

vim.api.nvim_set_keymap("v", ">", ">gv", {
  noremap = true,
  silent = true,
  desc = "Reselect visual selection after indenting",
})

vim.api.nvim_set_keymap("n", "j", '(v:count == 0 ? "gj" : "j")', {
  noremap = true,
  silent = true,
  expr = true,
  desc = "Move down by visual line (when text is wrapped unless count is provided)",
})

vim.api.nvim_set_keymap("n", "k", '(v:count == 0 ? "gk" : "k")', {
  noremap = true,
  silent = true,
  expr = true,
  desc = "Move up by visual line (when text is wrapped unless count is provided)",
})

vim.api.nvim_set_keymap("n", "<m-h>", ":vertical resize +1<cr>", {
  noremap = true,
  silent = true,
  desc = "Resize x +1",
})

vim.api.nvim_set_keymap("n", "<m-l>", ":vertical resize -1<cr>", {
  noremap = true,
  silent = true,
  desc = "Resize x -1",
})

vim.api.nvim_set_keymap("n", "<m-j>", ":resize +1<cr>", {
  noremap = true,
  silent = true,
  desc = "Resize y +1",
})

vim.api.nvim_set_keymap("n", "<m-k>", ":resize -1<cr>", {
  noremap = true,
  silent = true,
  desc = "Resize y -1",
})

vim.api.nvim_set_keymap("n", "[s", "[szz", {
  noremap = true,
  silent = true,
  desc = "Previous spelling error (centered)",
})

vim.api.nvim_set_keymap("n", "]s", "]szz", {
  noremap = true,
  silent = true,
  desc = "Next spelling error (centered)",
})

vim.api.nvim_set_keymap("n", "[b", "<cmd>bprevious<cr>", {
  noremap = true,
  silent = true,
  desc = "Previous buffer (ls)",
})

vim.api.nvim_set_keymap("n", "]b", "<cmd>bnext<cr>", {
  noremap = true,
  silent = true,
  desc = "Next buffer (ls)",
})

-- vim.api.nvim_set_keymap("n", "[a", "<cmd>previous<cr>", {
--   noremap = true,
--   silent = true,
--   desc = "Previous argument (args)",
-- })
--
-- vim.api.nvim_set_keymap("n", "]a", "<cmd>next<cr>", {
--   noremap = true,
--   silent = true,
--   desc = "Next argument (args)",
-- })

vim.api.nvim_set_keymap("n", "[q", "<cmd>cprevious<cr>", {
  noremap = true,
  silent = true,
  desc = "Previous quickfix list item (clist)",
})

vim.api.nvim_set_keymap("n", "]q", "<cmd>cnext<cr>", {
  noremap = true,
  silent = true,
  desc = "Next quickfix list item (clist)",
})

vim.api.nvim_set_keymap("n", "]t", "<cmd>tabnext<cr>", {
  noremap = true,
  silent = true,
  desc = "Next tab",
})

vim.api.nvim_set_keymap("n", "[t", "<cmd>tabprevious<cr>", {
  noremap = true,
  silent = true,
  desc = "Previous tab",
})

local function disable_arrow_key(mode, direction)
  vim.api.nvim_set_keymap(mode, direction, "", {
    noremap = true,
    silent = true,
    desc = ("Disable arrow key %s in mode %s"):format(direction, mode),
  })
end

disable_arrow_key("n", "<up>")
disable_arrow_key("n", "<down>")
disable_arrow_key("n", "<right>")
disable_arrow_key("n", "<left>")
disable_arrow_key("v", "<up>")
disable_arrow_key("v", "<down>")
disable_arrow_key("v", "<right>")
disable_arrow_key("v", "<left>")

vim.api.nvim_set_keymap("n", "n", "nzz", {
  noremap = true,
  silent = true,
  desc = "Display search results at center of screen",
})

vim.api.nvim_set_keymap("n", "N", "Nzz", {
  noremap = true,
  silent = true,
  desc = "Display search results at center of screen",
})

vim.api.nvim_set_keymap("n", "*", "*zzN", {
  noremap = true,
  silent = true,
  desc = "Display search results at center of screen (at the word invoked)",
})

vim.api.nvim_set_keymap("n", "#", "#zzN", {
  noremap = true,
  silent = true,
  desc = "Display search results at center of screen (at the word invoked)",
})

vim.api.nvim_set_keymap("n", "<c-u>", "<c-u>M", {
  noremap = true,
  silent = true,
  desc = "Move cursor to center of viewport after half-page up",
})

vim.api.nvim_set_keymap("n", "<c-d>", "<c-d>M", {
  noremap = true,
  silent = true,
  desc = "Move cursor to center of viewport after half-page down",
})

vim.api.nvim_set_keymap("n", "<c-h>", "<cmd>wincmd h<cr>", {
  noremap = true,
  silent = true,
  desc = "Move to window to the left",
})

vim.api.nvim_set_keymap("n", "<c-j>", "<cmd>wincmd j<cr>", {
  noremap = true,
  silent = true,
  desc = "Move to window below",
})

vim.api.nvim_set_keymap("n", "<c-k>", "<cmd>wincmd k<cr>", {
  noremap = true,
  silent = true,
  desc = "Move to window above",
})

vim.api.nvim_set_keymap("n", "<c-l>", "<cmd>wincmd l<cr>", {
  noremap = true,
  silent = true,
  desc = "Move to window to the right",
})

vim.api.nvim_set_keymap("i", "<<", "=", {
  silent = true,
  desc = "Replace << with = in insert mode",
})

vim.api.nvim_set_keymap("i", "<c-b>", "<left>", {
  silent = true,
  desc = "Move left in insert mode (left arrow)",
})

vim.api.nvim_set_keymap("i", "<c-l>", "<right>", {
  silent = true,
  desc = "Move right in insert mode (right arrow)",
})

vim.api.nvim_set_keymap("n", "H", "^", {
  noremap = true,
  silent = true,
  desc = "Move to the first character on the current line",
})

vim.api.nvim_set_keymap("n", "L", "g_", {
  noremap = true,
  silent = true,
  desc = "Move to the last character on the current line",
})

vim.api.nvim_set_keymap("n", "M", "%", {
  noremap = true,
  silent = true,
  desc = "Move to matching parenthesis",
})

-- start terminal: must hardcode terminal shell on windows to get pwsh (not sure if this needs to be hardcoded any longer or if this is related to fileextension etc.)
-- local term_str = "<cmd>belowright split term://" .. vim.opt.shell:get() .. " | resize -10<cr>i"
-- if utils.IS_WIN then
--   term_str = "<cmd>belowright split term://pwsh | resize -10<cr>i"
-- end
-- vim.api.nvim_set_keymap("n", "<leader>t", term_str, {
--   noremap = true,
--   desc = [[Start a terminal buffer in 'terminal mode']],
-- })

vim.api.nvim_set_keymap("n", "<leader>y", [["+y]], {
  noremap = true,
  desc = "Yank to clipboard register",
})

vim.api.nvim_set_keymap("n", "<leader>p", [["+p]], {
  noremap = true,
  desc = "Paste from clipboard register",
})

vim.api.nvim_set_keymap("n", "<leader>w", "<cmd>up<cr>", {
  noremap = true,
  desc = "Write file if updated",
})

vim.api.nvim_set_keymap("n", "<leader>sub", ":%s///gc<left><left><left><left>", {
  noremap = true,
  desc = "Insert substitute command",
})

vim.api.nvim_set_keymap("n", "<leader>gl", ":g//<left>", {
  noremap = true,
  desc = "Insert global command",
})

vim.api.nvim_set_keymap("n", "<leader>ef", ':e <c-r>=expand("%:p:h")."/"<cr>', {
  noremap = true,
  desc = "Edit file in current window (at present path)",
})

vim.api.nvim_set_keymap("n", "<leader>eh", ':split <c-r>=expand("%:p:h")."/"<cr>', {
  noremap = true,
  desc = "Edit file in horizontal split (at present path)",
})

vim.api.nvim_set_keymap("n", "<leader>ev", ':vsplit <c-r>=expand("%:p:h")."/"<cr>', {
  noremap = true,
  desc = "Edit file in vertical split (at present path)",
})

vim.api.nvim_set_keymap("n", "<leader>en", "<cmd>vnew<cr>", {
  noremap = true,
  desc = "Open new empty buffer in vertical split",
})

vim.api.nvim_set_keymap("n", "<leader>co", "<cmd>copen<cr>", {
  noremap = true,
  desc = "Open quickfix list",
})

vim.api.nvim_set_keymap("n", "<leader>cc", "<cmd>cclose<cr>", {
  noremap = true,
  desc = "Close quickfix list",
})

-- vim.api.nvim_set_keymap("n", "<leader>j", "}", {
--   noremap = true,
--   silent = true,
--   desc = "Move to next paragraph",
-- })
--
-- vim.api.nvim_set_keymap("n", "<leader>k", "{", {
--   noremap = true,
--   silent = true,
--   desc = "Move to previous paragraph",
-- })

vim.api.nvim_set_keymap("n", "<leader><leader>", "<c-^>", {
  noremap = true,
  silent = true,
  desc = "Toggle between active and alternate buffer",
})

vim.api.nvim_set_keymap("n", "<leader>bd", [[<cmd>lclose|b#|bd! #<cr>]], {
  noremap = true,
  silent = true,
  desc = "Delete buffer in normal mode (after switching to alternate buffer)",
})

vim.keymap.set("n", "<leader>bf", function()
  if vim.wo.winfixbuf then
    vim.opt_local.winfixbuf = false
    vim.notify("Disabled winfixbuf for buffer")
  else
    vim.opt_local.winfixbuf = true
    vim.notify("Enabled winfixbuf for buffer")
  end
end, {
  noremap = true,
  silent = true,
  desc = "Fix buffer to window (toggle command)",
})

vim.api.nvim_set_keymap("n", "<localleader><c-enter>", [[<cmd>make<cr>]], {
  noremap = true,
  silent = true,
  desc = "Run script in buffer (compile script)",
})
