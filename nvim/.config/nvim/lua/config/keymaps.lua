-- general key mappings
-- plugin specific keymaps are generally set in each plugin configuration

local map = function(mode, l, r, opts)
  opts = opts or {}
  vim.keymap.set(mode, l, r, opts)
end

map("n", "gl", "G", {
  noremap = true,
  silent = true,
  desc = "Go to last line in buffer (more convenient than G)",
})

map("x", "/", "<esc>/\\%V", {
  noremap = true,
  silent = false,
  desc = "Search only in visual selected text",
})

map("n", "u", "<cmd>silent undo<cr>", {
  noremap = true,
  silent = true,
  desc = "Undo (silent)",
})

map("n", "U", "<cmd>silent redo<cr>", {
  noremap = true,
  silent = true,
  desc = "Redo (silent)",
})

map("n", "<esc>", ":", {
  noremap = true,
  silent = false,
  desc = "Escape in normal mode to enter command-line mode",
})

map("t", "<esc>", [[<c-\><c-n>]], {
  noremap = true,
  silent = true,
  desc = "Switch to normal mode from terminal mode",
})

map({ "n", "x" }, "<c-t>", function()
  local snacks_exists, snacks = pcall(require, "snacks")
  if snacks_exists then
    vim.cmd([[echo ""]])
    snacks.notifier.hide()
    vim.cmd.nohlsearch()
    return
  end
  local noice_exists, _ = pcall(require, "noice")
  if noice_exists then
    vim.cmd([[echo ""]])
    vim.cmd.NoiceDismiss()
    vim.cmd.nohlsearch()
    return
  end
end, {
  noremap = true,
  silent = true,
  desc = "Remove search highlight and notification pop-ups",
})

map("n", "ycc", "yygccp", {
  remap = true,
  silent = true,
  desc = "Yank/paste the current line and then comment the same line",
})

map("v", "<", "<gv", {
  noremap = true,
  silent = true,
  desc = "Reselect visual selection after de-indenting",
})

map("v", ">", ">gv", {
  noremap = true,
  silent = true,
  desc = "Reselect visual selection after indenting",
})

map("n", "j", '(v:count == 0 ? "gj" : "j")', {
  noremap = true,
  silent = true,
  expr = true,
  desc = "Move down by visual line (when text is wrapped unless count is provided)",
})

map("n", "k", '(v:count == 0 ? "gk" : "k")', {
  noremap = true,
  silent = true,
  expr = true,
  desc = "Move up by visual line (when text is wrapped unless count is provided)",
})

map("n", "<m-h>", "<cmd>vertical resize +1<cr>", {
  noremap = true,
  silent = true,
  desc = "Resize x +1",
})

map("n", "<m-l>", "<cmd>vertical resize -1<cr>", {
  noremap = true,
  silent = true,
  desc = "Resize x -1",
})

map("n", "<m-j>", "<cmd>resize +1<cr>", {
  noremap = true,
  silent = true,
  desc = "Resize y +1",
})

map("n", "<m-k>", "<cmd>resize -1<cr>", {
  noremap = true,
  silent = true,
  desc = "Resize y -1",
})

map("n", "[s", "[s", {
  noremap = true,
  silent = true,
  desc = "Previous spelling error",
})

map("n", "]s", "]s", {
  noremap = true,
  silent = true,
  desc = "Next spelling error",
})

map("n", "[b", "<cmd>bprevious<cr>", {
  noremap = true,
  silent = true,
  desc = "Previous buffer (ls)",
})

map("n", "]b", "<cmd>bnext<cr>", {
  noremap = true,
  silent = true,
  desc = "Next buffer (ls)",
})

map("n", "[q", "<cmd>cprevious<cr>", {
  noremap = true,
  silent = true,
  desc = "Previous quickfix list item (clist)",
})

map("n", "]q", "<cmd>cnext<cr>", {
  noremap = true,
  silent = true,
  desc = "Next quickfix list item (clist)",
})

map("n", "]t", "<cmd>tabnext<cr>", {
  noremap = true,
  silent = true,
  desc = "Next tab",
})

map("n", "[t", "<cmd>tabprevious<cr>", {
  noremap = true,
  silent = true,
  desc = "Previous tab",
})

map("n", "<up>", "", { noremap = true, silent = true, desc = "Disable arrow key <up>" })
map("n", "<down>", "", { noremap = true, silent = true, desc = "Disable arrow key <down>" })
map("n", "<right>", "", { noremap = true, silent = true, desc = "Disable arrow key <right>" })
map("n", "<left>", "", { noremap = true, silent = true, desc = "Disable arrow key <left>" })
map("v", "<up>", "", { noremap = true, silent = true, desc = "Disable arrow key <up>" })
map("v", "<down>", "", { noremap = true, silent = true, desc = "Disable arrow key <down>" })
map("v", "<right>", "", { noremap = true, silent = true, desc = "Disable arrow key <right>" })
map("v", "<left>", "", { noremap = true, silent = true, desc = "Disable arrow key <left>" })

map("n", "n", "nzz", {
  noremap = true,
  silent = true,
  desc = "Display search results at center of screen",
})

map("n", "N", "Nzz", {
  noremap = true,
  silent = true,
  desc = "Display search results at center of screen",
})

map("n", "*", "*zzN", {
  noremap = true,
  silent = true,
  desc = "Display search results at center of screen (at the word invoked)",
})

map("n", "#", "#zzN", {
  noremap = true,
  silent = true,
  desc = "Display search results at center of screen (at the word invoked)",
})

map("n", "<c-u>", "<c-u>M", {
  noremap = true,
  silent = true,
  desc = "Move cursor to center of viewport after half-page up",
})

map("n", "<c-d>", "<c-d>M", {
  noremap = true,
  silent = true,
  desc = "Move cursor to center of viewport after half-page down",
})

map("n", "<c-h>", "<cmd>wincmd h<cr>", {
  noremap = true,
  silent = true,
  desc = "Move to window to the left",
})

map("n", "<c-j>", "<cmd>wincmd j<cr>", {
  noremap = true,
  silent = true,
  desc = "Move to window below",
})

map("n", "<c-k>", "<cmd>wincmd k<cr>", {
  noremap = true,
  silent = true,
  desc = "Move to window above",
})

map("n", "<c-l>", "<cmd>wincmd l<cr>", {
  noremap = true,
  silent = true,
  desc = "Move to window to the right",
})

map("i", "<<", "=", {
  silent = true,
  desc = "Replace << with = in insert mode",
})

-- readline keymaps (a subset)
map("i", "<c-b>", "<left>", {
  silent = true,
  desc = "Move left in insert mode (left arrow)",
})

map({ "i", "c" }, "<c-l>", "<right>", {
  silent = true,
  desc = "Move right in insert/command mode (right arrow)",
})

map("i", "<c-f>", "<right>", {
  silent = true,
  desc = "Move right in insert mode (right arrow)",
})

map("i", "<c-k>", "<c-g>u<c-o>d$", {
  silent = true,
  desc = "Delete line forward",
})

map("n", "H", "^", {
  noremap = true,
  silent = true,
  desc = "Move to the first character on the current line",
})

map("n", "L", "g_", {
  noremap = true,
  silent = true,
  desc = "Move to the last character on the current line",
})

map("n", "M", "%", {
  noremap = true,
  silent = true,
  desc = "Move to matching parenthesis",
})

map("n", "Y", "yg_", {
  noremap = true,
  desc = "Yank to end of line (without end of line whitespace)",
})

map("x", "y", "zy", {
  noremap = true,
  desc = "Yank without trailing blanks (block visual mode)",
})

map("n", "p", "zp", {
  noremap = true,
  desc = "Paste a block of text without trailing blanks",
})

map("n", "P", "zP", {
  noremap = true,
  desc = "Paste a block of text before cursor without trailing blanks",
})

-- leader mappings
map("n", "<leader>y", [["+y]], {
  noremap = true,
  desc = "Yank to clipboard register",
})
map("n", "<leader>p", [["+p]], {
  noremap = true,
  desc = "Paste from clipboard register",
})

map("n", "<leader>w", "<cmd>silent up<cr>", {
  noremap = true,
  silent = true,
  desc = "Write file if updated",
})

map("n", "<leader>sub", ":%s///gc<left><left><left><left>", {
  noremap = true,
  desc = "Insert substitute command",
})

map("n", "<leader>gl", ":g//<left>", {
  noremap = true,
  desc = "Insert global command",
})

map("n", "<leader>ef", ':e <c-r>=expand("%:p:h")."/"<cr>', {
  noremap = true,
  desc = "Edit file in current window",
})

map("n", "<leader>eh", ':split <c-r>=expand("%:p:h")."/"<cr>', {
  noremap = true,
  desc = "Edit file in horizontal split",
})

map("n", "<leader>ev", ':vsplit <c-r>=expand("%:p:h")."/"<cr>', {
  noremap = true,
  desc = "Edit file in vertical split",
})

map("n", "<leader>en", "<cmd>vnew<cr>", {
  noremap = true,
  desc = "Open new empty buffer in vertical split",
})

map("n", "<leader>co", "<cmd>copen<cr>", {
  noremap = true,
  desc = "Open quickfix list",
})

map("n", "<leader>cc", "<cmd>cclose<cr>", {
  noremap = true,
  desc = "Close quickfix list",
})

map("n", "<leader><leader>", "<c-^>", {
  noremap = true,
  silent = true,
  desc = "Toggle between active and alternate buffer",
})

-- use Snacks.bufdelete with below fallback
map("n", "<leader>bd", function()
  local snacks_exists, snacks = pcall(require, "snacks")
  if snacks_exists then
    snacks.bufdelete()
  else
    vim.cmd([[:lclose|b#|bd! #]])
  end
end, {
  noremap = true,
  silent = true,
  desc = "Delete buffer in normal mode (after switching to alternate buffer)",
})

map("n", "<leader>bf", function()
  if vim.wo.winfixbuf then
    vim.wo.winfixbuf = false
    vim.notify("Disabled winfixbuf for buffer")
  else
    vim.wo.winfixbuf = true
    vim.notify("Enabled winfixbuf for buffer")
  end
end, {
  noremap = true,
  silent = true,
  desc = "Fix buffer to window (toggle command)",
})

-- localleader mapping
map({ "n", "x" }, "<localleader>dd", function()
  local mode = vim.api.nvim_get_mode().mode
  if mode == "n" then
    vim.cmd([[normal "_dd]])
  elseif vim.tbl_contains({ "v", "V" }, mode) then
    vim.cmd([[normal "_d]])
  end
end, {
  noremap = true,
  silent = true,
  desc = "Delete line(s) without yanking",
})

map("n", "<localleader>tb", function()
  require("config.utils").toggle_boolean()
end, {
  noremap = true,
  silent = true,
  desc = "Toggle boolean under the cursor",
})

-- omnifunc completion related keymaps
map("i", "<c-c>", function()
  return vim.fn.pumvisible() == 1 and "<c-e>" or "<c-c>"
end, {
  noremap = true,
  silent = false,
  expr = true,
  desc = "Close completion menu (otherwise return key itself)",
})
