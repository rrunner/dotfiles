-- general key mappings
-- plugin specific keymaps are generally set in each plugin configuration

vim.keymap.set("x", "/", "<esc>/\\%V", {
  noremap = true,
  silent = false,
  desc = "Search only in visual selected text",
})

vim.keymap.set("n", "u", "<cmd>silent undo<cr>", {
  noremap = true,
  silent = true,
  desc = "Undo (silent)",
})

vim.keymap.set("n", "U", "<cmd>silent redo<cr>", {
  noremap = true,
  silent = true,
  desc = "Redo (silent)",
})

vim.keymap.set("n", "<esc>", ":", {
  noremap = true,
  silent = false,
  desc = "Escape in normal mode to enter command-line mode",
})

vim.keymap.set("t", "<esc>", [[<c-\><c-n>]], {
  noremap = true,
  silent = true,
  desc = "Switch to normal mode from terminal mode",
})

vim.keymap.set({ "n", "x" }, "<c-t>", function()
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

vim.keymap.set("n", "ycc", "yygccp", {
  remap = true,
  silent = true,
  desc = "Yank/paste the current line and then comment the same line",
})

vim.keymap.set("v", "<", "<gv", {
  noremap = true,
  silent = true,
  desc = "Reselect visual selection after de-indenting",
})

vim.keymap.set("v", ">", ">gv", {
  noremap = true,
  silent = true,
  desc = "Reselect visual selection after indenting",
})

vim.keymap.set("n", "j", '(v:count == 0 ? "gj" : "j")', {
  noremap = true,
  silent = true,
  expr = true,
  desc = "Move down by visual line (when text is wrapped unless count is provided)",
})

vim.keymap.set("n", "k", '(v:count == 0 ? "gk" : "k")', {
  noremap = true,
  silent = true,
  expr = true,
  desc = "Move up by visual line (when text is wrapped unless count is provided)",
})

vim.keymap.set("n", "<m-h>", "<cmd>vertical resize +1<cr>", {
  noremap = true,
  silent = true,
  desc = "Resize x +1",
})

vim.keymap.set("n", "<m-l>", "<cmd>vertical resize -1<cr>", {
  noremap = true,
  silent = true,
  desc = "Resize x -1",
})

vim.keymap.set("n", "<m-j>", "<cmd>resize +1<cr>", {
  noremap = true,
  silent = true,
  desc = "Resize y +1",
})

vim.keymap.set("n", "<m-k>", "<cmd>resize -1<cr>", {
  noremap = true,
  silent = true,
  desc = "Resize y -1",
})

vim.keymap.set("n", "[s", "[s", {
  noremap = true,
  silent = true,
  desc = "Previous spelling error",
})

vim.keymap.set("n", "]s", "]s", {
  noremap = true,
  silent = true,
  desc = "Next spelling error",
})

vim.keymap.set("n", "[b", "<cmd>bprevious<cr>", {
  noremap = true,
  silent = true,
  desc = "Previous buffer (ls)",
})

vim.keymap.set("n", "]b", "<cmd>bnext<cr>", {
  noremap = true,
  silent = true,
  desc = "Next buffer (ls)",
})

vim.keymap.set("n", "[q", "<cmd>cprevious<cr>", {
  noremap = true,
  silent = true,
  desc = "Previous quickfix list item (clist)",
})

vim.keymap.set("n", "]q", "<cmd>cnext<cr>", {
  noremap = true,
  silent = true,
  desc = "Next quickfix list item (clist)",
})

vim.keymap.set("n", "]t", "<cmd>tabnext<cr>", {
  noremap = true,
  silent = true,
  desc = "Next tab",
})

vim.keymap.set("n", "[t", "<cmd>tabprevious<cr>", {
  noremap = true,
  silent = true,
  desc = "Previous tab",
})

vim.keymap.set("n", "<up>", "", { noremap = true, silent = true, desc = "Disable arrow key <up>" })
vim.keymap.set("n", "<down>", "", { noremap = true, silent = true, desc = "Disable arrow key <down>" })
vim.keymap.set("n", "<right>", "", { noremap = true, silent = true, desc = "Disable arrow key <right>" })
vim.keymap.set("n", "<left>", "", { noremap = true, silent = true, desc = "Disable arrow key <left>" })
vim.keymap.set("v", "<up>", "", { noremap = true, silent = true, desc = "Disable arrow key <up>" })
vim.keymap.set("v", "<down>", "", { noremap = true, silent = true, desc = "Disable arrow key <down>" })
vim.keymap.set("v", "<right>", "", { noremap = true, silent = true, desc = "Disable arrow key <right>" })
vim.keymap.set("v", "<left>", "", { noremap = true, silent = true, desc = "Disable arrow key <left>" })

vim.keymap.set("n", "n", "nzz", {
  noremap = true,
  silent = true,
  desc = "Display search results at center of screen",
})

vim.keymap.set("n", "N", "Nzz", {
  noremap = true,
  silent = true,
  desc = "Display search results at center of screen",
})

vim.keymap.set("n", "*", function()
  require("config.utils").run_wo_snacks_scroll(function()
    vim.cmd([[echo "" | silent normal! *zzN]])
  end)
end, {
  noremap = true,
  silent = true,
  desc = "Display search results at center of screen (at the word invoked)",
})

vim.keymap.set("n", "#", "#zzN", {
  noremap = true,
  silent = true,
  desc = "Display search results at center of screen (at the word invoked)",
})

vim.keymap.set("n", "<c-u>", function()
  vim.wo.scrolloff = 999
  vim.defer_fn(function()
    vim.wo.scrolloff = 8
  end, 500)
  return "<c-u>"
end, {
  noremap = true,
  silent = true,
  expr = true,
  desc = "Move cursor to center of viewport after half-page up",
})

vim.keymap.set("n", "<c-d>", function()
  vim.wo.scrolloff = 999
  vim.defer_fn(function()
    vim.wo.scrolloff = 8
  end, 500)
  return "<c-d>"
end, {
  noremap = true,
  silent = true,
  expr = true,
  desc = "Move cursor to center of viewport after half-page down",
})

vim.keymap.set("n", "<c-h>", "<cmd>wincmd h<cr>", {
  noremap = true,
  silent = true,
  desc = "Move to window to the left",
})

vim.keymap.set("n", "<c-j>", "<cmd>wincmd j<cr>", {
  noremap = true,
  silent = true,
  desc = "Move to window below",
})

vim.keymap.set("n", "<c-k>", "<cmd>wincmd k<cr>", {
  noremap = true,
  silent = true,
  desc = "Move to window above",
})

vim.keymap.set("n", "<c-l>", "<cmd>wincmd l<cr>", {
  noremap = true,
  silent = true,
  desc = "Move to window to the right",
})

vim.keymap.set("i", "<<", "=", {
  silent = true,
  desc = "Replace << with = in insert mode",
})

-- readline keymaps (a subset)
vim.keymap.set("i", "<c-b>", "<left>", {
  silent = true,
  desc = "Move left in insert mode (left arrow)",
})

vim.keymap.set("i", "<c-l>", "<right>", {
  silent = true,
  desc = "Move right in insert mode (right arrow)",
})

vim.keymap.set("i", "<c-f>", "<right>", {
  silent = true,
  desc = "Move right in insert mode (right arrow)",
})

vim.keymap.set("i", "<c-k>", "<c-g>u<c-o>d$", {
  silent = true,
  desc = "Delete line forward",
})

vim.keymap.set("n", "H", function()
  local cursor_column = vim.api.nvim_win_get_cursor(0)[2]
  vim.cmd("normal! ^")
  local cursor_column_update = vim.api.nvim_win_get_cursor(0)[2]
  if cursor_column == cursor_column_update then
    vim.cmd("normal! 0")
  end
end, {
  noremap = true,
  silent = true,
  desc = "Move to the first character/column on the current line",
})

vim.keymap.set("n", "L", function()
  local cursor_column = vim.api.nvim_win_get_cursor(0)[2]
  vim.cmd("normal! g_")
  local cursor_column_update = vim.api.nvim_win_get_cursor(0)[2]
  if cursor_column == cursor_column_update then
    vim.cmd("normal! $")
  end
end, {
  noremap = true,
  silent = true,
  desc = "Move to the last character/column on the current line",
})

vim.keymap.set("n", "M", "%", {
  noremap = true,
  silent = true,
  desc = "Move to matching parenthesis",
})

vim.keymap.set("n", "Y", "yg_", {
  noremap = true,
  desc = "Yank to end of line (without end of line whitespace)",
})

vim.keymap.set("x", "y", "zy", {
  noremap = true,
  desc = "Yank without trailing blanks (block visual mode)",
})

vim.keymap.set("n", "p", "zp", {
  noremap = true,
  desc = "Paste a block of text without trailing blanks",
})

vim.keymap.set("n", "P", "zP", {
  noremap = true,
  desc = "Paste a block of text before cursor without trailing blanks",
})

-- leader mappings
vim.keymap.set("n", "<leader>y", [["+y]], {
  noremap = true,
  desc = "Yank to clipboard register",
})

vim.keymap.set("n", "<leader>p", [["+p]], {
  noremap = true,
  desc = "Paste from clipboard register",
})

vim.keymap.set("n", "<leader>w", "<cmd>silent up<cr>", {
  noremap = true,
  silent = true,
  desc = "Write file if updated",
})

vim.keymap.set("n", "<leader>sub", ":%s///gc<left><left><left><left>", {
  noremap = true,
  desc = "Insert substitute command",
})

vim.keymap.set("n", "<leader>gl", ":g//<left>", {
  noremap = true,
  desc = "Insert global command",
})

vim.keymap.set("n", "<leader>ef", ':e <c-r>=expand("%:p:h")."/"<cr>', {
  noremap = true,
  desc = "Edit file in current window",
})

vim.keymap.set("n", "<leader>eh", ':split <c-r>=expand("%:p:h")."/"<cr>', {
  noremap = true,
  desc = "Edit file in horizontal split",
})

vim.keymap.set("n", "<leader>ev", ':vsplit <c-r>=expand("%:p:h")."/"<cr>', {
  noremap = true,
  desc = "Edit file in vertical split",
})

vim.keymap.set("n", "<leader>en", "<cmd>vnew<cr>", {
  noremap = true,
  desc = "Open new empty buffer in vertical split",
})

vim.keymap.set("n", "<leader>co", function()
  -- avoid opening quickfix list inside Snacks explorer window
  require("config.utils").close_explorer_picker()
  vim.schedule(function()
    vim.cmd.copen()
  end)
end, {
  noremap = true,
  desc = "Open quickfix list",
})

vim.keymap.set("n", "<leader>cc", "<cmd>cclose<cr>", {
  noremap = true,
  desc = "Close quickfix list",
})

vim.keymap.set("n", "<leader><leader>", "<c-^>", {
  noremap = true,
  silent = true,
  desc = "Toggle between active and alternate buffer",
})

-- use Snacks.bufdelete with below fallback
vim.keymap.set("n", "<leader>bd", function()
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

vim.keymap.set("n", "<leader>bf", function()
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
vim.keymap.set({ "n", "x" }, "<localleader>dd", function()
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

vim.keymap.set("n", "<localleader>tb", function()
  require("config.utils").toggle_boolean()
end, {
  noremap = true,
  silent = true,
  desc = "Toggle boolean under the cursor",
})

-- omnifunc completion related keymaps
vim.keymap.set("i", "<c-c>", function()
  return vim.fn.pumvisible() == 1 and "<c-e>" or "<c-c>"
end, {
  noremap = true,
  silent = false,
  expr = true,
  desc = "Close completion menu (otherwise return key itself)",
})
