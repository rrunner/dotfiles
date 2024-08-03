local utils = require("config.utils")
local config = vim.api.nvim_create_augroup("Config", { clear = true })

-- highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank({ timeout = 700 })
  end,
  group = config,
  pattern = "*",
})

-- settings applied to a new terminal
vim.api.nvim_create_autocmd("TermOpen", {
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.signcolumn = "no"
    vim.opt_local.statuscolumn = ""
  end,
  group = config,
  pattern = "*",
})

-- close terminal
vim.api.nvim_create_autocmd("TermClose", {
  command = [[silent! if !v:event.status | exe 'bdelete! '..expand('<abuf>') | endif]],
  group = config,
  pattern = "*",
})

-- close specific filetypes with "q"
vim.api.nvim_create_autocmd("FileType", {
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set(
      "n",
      "q",
      "<cmd>close<cr>",
      { noremap = true, silent = true, buffer = event.buf, desc = "Close specific filetypes with q (autocmd)" }
    )
  end,
  group = config,
  pattern = { "help", "qf", "checkhealth", "neotest-summary", "neotest-output", "query", "gitsigns-blame" },
})

-- close command line window (q:, q/ and q? etc.) with "q"
vim.api.nvim_create_autocmd("CmdwinEnter", {
  command = [[nnoremap <buffer><silent> q :close<cr>]],
  group = config,
  pattern = "*",
})

-- unset statuscolumn based on events filetype and bufenter
vim.api.nvim_create_autocmd({ "FileType", "BufEnter" }, {
  callback = function(event)
    local exc_ft = { "neo-tree", "NeogitStatus" }
    if vim.tbl_contains(exc_ft, vim.bo[event.buf].filetype) then
      vim.opt_local.statuscolumn = ""
    end
  end,
  group = config,
  pattern = "*",
})

-- make autoread work as expected on Windows OS
if utils.IS_WIN then
  -- auto-reload files when modified externally
  vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "CursorHoldI", "FocusGained" }, {
    command = "if mode() != 'c' | checktime | endif",
    group = config,
    pattern = "*",
  })
end

-- use internal formatting for bindings like gq
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(event)
    vim.bo[event.buf].formatexpr = nil
  end,
  group = config,
  pattern = "*",
})

-- notification during macro recording
vim.api.nvim_create_autocmd("RecordingEnter", {
  callback = function()
    vim.notify("Macro recording to register " .. vim.fn.reg_recording(), vim.log.levels.INFO, {
      title = "Macro recording",
      keep = function()
        return vim.fn.reg_recording() ~= ""
      end,
    })
  end,
  group = config,
  pattern = "*",
})

-- set/unset winbar (global winbar setting must be unset)
vim.api.nvim_create_autocmd({ "BufWinEnter", "BufFilePost", "WinEnter" }, {
  callback = function()
    -- winbar whitelist
    local ft_with_winbar =
      { "python", "r", "rmd", "sql", "yaml", "json", "lua", "text", "quarto", "markdown", "tex", "toml" }

    -- exclusions
    if utils.is_non_normal_buffer() or not vim.tbl_contains(ft_with_winbar, vim.bo[0].filetype) then
      vim.opt_local.winbar = ""
      return
    end

    vim.opt_local.winbar = "%=%m%r%{expand('%:p:h:t')}/%t"
  end,
  group = config,
  pattern = "*",
})

-- show cursor line only in active window
vim.api.nvim_create_autocmd({ "InsertLeave", "WinEnter" }, {
  callback = function()
    vim.opt_local.cursorline = true
  end,
  group = config,
  pattern = "*",
})
vim.api.nvim_create_autocmd({ "InsertEnter", "WinLeave" }, {
  callback = function(event)
    local whitelist = { "neo-tree" }
    if vim.tbl_contains(whitelist, vim.bo[event.buf].filetype) then
      return
    end
    vim.opt_local.cursorline = false
  end,
  group = config,
  pattern = "*",
})

-- enable spell checking for certain file types
vim.api.nvim_create_autocmd("FileType", {
  callback = function()
    vim.opt_local.spell = true
    vim.opt_local.spelllang = { "en", "sv" }
    vim.opt_local.spelloptions:append({ "camel" })
  end,
  group = config,
  pattern = { "text", "tex", "markdown", "quarto", "rmd", "mail", "NeogitCommitMessage" },
})

-- delete [No Name] buffers
vim.api.nvim_create_autocmd("BufHidden", {
  callback = function(event)
    if event.file == "" and vim.bo[event.buf].buftype == "" and not vim.bo[event.buf].modified then
      vim.schedule(function()
        pcall(vim.api.nvim_buf_delete, event.buf, {})
      end)
    end
  end,
  group = config,
  pattern = "*",
})

-- resize splits when terminal is resized
vim.api.nvim_create_autocmd("VimResized", {
  command = "wincmd =",
  group = config,
  pattern = "*",
})

-- set filetype for *.mail
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  command = "set filetype=mail",
  group = config,
  pattern = "*.mail",
})

-- open file at the last edited position (for configuration files)
vim.api.nvim_create_autocmd("BufReadPost", {
  command = 'silent! normal! g`"zv',
  group = config,
  pattern = { "*.toml", "*.yaml", "*.yml" },
})

-- only use number in insert mode (not relativenumber) if number option is set
vim.api.nvim_create_autocmd("InsertEnter", {
  callback = function()
    ---@diagnostic disable-next-line: undefined-field
    if vim.opt_local.number:get() then
      vim.opt_local.number = true
      vim.opt_local.relativenumber = false
    end
  end,
  group = config,
  pattern = "*",
})
vim.api.nvim_create_autocmd("InsertLeave", {
  callback = function()
    ---@diagnostic disable-next-line: undefined-field
    if vim.opt_local.number:get() then
      vim.opt_local.number = true
      vim.opt_local.relativenumber = true
    end
  end,
  group = config,
  pattern = "*",
})

-- quarto preview file
vim.api.nvim_create_autocmd("FileType", {
  callback = function()
    vim.api.nvim_set_keymap("n", "<localleader>qp", [[<cmd>lua require("config.utils").quarto_preview()<cr>]], {
      noremap = true,
      silent = true,
      desc = "Quarto preview file",
    })
  end,
  group = config,
  pattern = { "markdown", "quarto", "rmd", "json" },
})

-- keep terminal background's color in sync with Neovim's background color using OSC control sequences (https://github.com/neovim/neovim/issues/16572#issuecomment-1954420136)
local modified = false
vim.api.nvim_create_autocmd({ "UIEnter", "ColorScheme" }, {
  callback = function()
    local normal = vim.api.nvim_get_hl(0, { name = "Normal" })
    if normal.bg then
      io.write(string.format("\027]11;#%06x\027\\", normal.bg))
      modified = true
    end
  end,
})

vim.api.nvim_create_autocmd("UILeave", {
  callback = function()
    if modified then
      io.write("\027]111\027\\")
    end
  end,
})
