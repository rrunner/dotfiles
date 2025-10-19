local utils = require("config.utils")
local config = vim.api.nvim_create_augroup("Config", { clear = true })

-- highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    (vim.hl or vim.highlight).on_yank({ timeout = 700 })
  end,
  group = config,
  pattern = "*",
})

-- settings applied to a new terminal
vim.api.nvim_create_autocmd("TermOpen", {
  callback = function(event)
    local winid = vim.fn.bufwinid(event.buf)
    vim.wo[winid][0].number = false
    vim.wo[winid][0].relativenumber = false
    vim.wo[winid][0].signcolumn = "no"
    vim.wo[winid][0].statuscolumn = ""
  end,
  group = config,
  pattern = "*",
})

-- auto-close terminal when process exits
vim.api.nvim_create_autocmd("TermClose", {
  -- command = [[silent! if !v:event.status | exe 'bdelete! '..expand('<abuf>') | endif]],
  callback = function()
    if vim.v.event.status == 0 then
      vim.api.nvim_buf_delete(0, {})
    end
  end,
  group = config,
  pattern = "*",
})

-- close specific filetypes with "q"
vim.api.nvim_create_autocmd("FileType", {
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.schedule(function()
      vim.keymap.set("n", "q", function()
        vim.cmd("close")
      end, {
        noremap = true,
        silent = true,
        buffer = event.buf,
        desc = "Close specific filetypes with q (autocmd)",
      })
    end)
  end,
  group = config,
  pattern = {
    "help",
    "qf",
    "checkhealth",
    "neotest-summary",
    "neotest-output",
    "query",
    "gitsigns-blame",
    "git",
    "diff",
  },
})

-- close command line window (q:, q/ and q? etc.) with "q"
vim.api.nvim_create_autocmd("CmdwinEnter", {
  command = [[nnoremap <buffer><silent> q :close<cr>]],
  group = config,
  pattern = "*",
})

-- make autoread work as expected on Windows OS
if utils.IS_WIN then
  -- auto-reload files when modified externally
  vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "CursorHoldI", "FocusGained" }, {
    command = [[if mode() != 'c' | checktime | endif]],
    group = config,
    pattern = "*",
  })
else
  -- check if we need to reload the file when it changed (maybe this can replace the autocmd for win above)
  vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
    callback = function()
      if vim.o.buftype ~= "nofile" then
        vim.cmd("checktime")
      end
    end,
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

-- set/unset winbar (global winbar setting must be unset)
vim.api.nvim_create_autocmd({ "BufWinEnter", "BufFilePost", "WinEnter" }, {
  callback = function(event)
    -- winbar whitelist
    local ft_with_winbar = {
      "haskell",
      "json",
      "jsonc",
      "lua",
      "markdown",
      "python",
      "quarto",
      "r",
      "rmd",
      "sql",
      "tex",
      "text",
      "toml",
      "yaml",
    }

    -- exclusions
    local ft = vim.bo[0].filetype
    local winid = vim.fn.bufwinid(event.buf)
    if utils.is_non_normal_buffer() or not vim.tbl_contains(ft_with_winbar, ft) then
      vim.wo[winid][0].winbar = ""
      return
    end

    vim.wo[winid][0].winbar = "%=" .. utils.get_filetype_icon(ft) .. "%m%r%{expand('%:p:h:t')}/%t"
  end,
  group = config,
  pattern = "*",
})

-- show cursor line only in active window
vim.api.nvim_create_autocmd({ "InsertLeave", "WinEnter" }, {
  callback = function(event)
    local winid = vim.fn.bufwinid(event.buf)
    vim.wo[winid][0].cursorline = true
  end,
  group = config,
  pattern = "*",
})
vim.api.nvim_create_autocmd({ "InsertEnter", "WinLeave" }, {
  callback = function(event)
    local winid = vim.fn.bufwinid(event.buf)
    vim.wo[winid][0].cursorline = false
  end,
  group = config,
  pattern = "*",
})

-- enable spell checking for certain file types
vim.api.nvim_create_autocmd("FileType", {
  callback = function(event)
    local bufnr = event.buf
    local winid = vim.fn.bufwinid(bufnr)
    vim.wo[winid][0].spell = true
    vim.bo[bufnr].spelllang = "en,sv"
    vim.bo[bufnr].spelloptions = "camel"
  end,
  group = config,
  pattern = { "text", "tex", "markdown", "quarto", "rmd", "mail", "NeogitCommitMessage", "plaintex", "gitcommit" },
})

-- enable wrap for certain file types not covered by "after"
vim.api.nvim_create_autocmd("FileType", {
  callback = function()
    vim.wo.wrap = true
  end,
  group = config,
  pattern = { "quarto", "rmd", "NeogitCommitMessage", "plaintex", "gitcommit" },
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

-- resize splits for each tab if window is resized
vim.api.nvim_create_autocmd({ "VimResized" }, {
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd("tabdo wincmd =")
    vim.cmd("tabnext " .. current_tab)
  end,
  group = config,
  pattern = "*",
})

-- set filetype for *.mail
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  command = [[set filetype=mail]],
  group = config,
  pattern = "*.mail",
})

-- open file at the last edited position (for configuration files)
vim.api.nvim_create_autocmd("BufReadPost", {
  callback = function(event)
    local bufnr = event.buf
    if vim.b[bufnr].last_loc then
      -- open file normally if the buffer is already open
      return
    end
    vim.b[bufnr].last_loc = true
    local mark = vim.api.nvim_buf_get_mark(bufnr, ".")
    local lcount = vim.api.nvim_buf_line_count(bufnr)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
  group = config,
  pattern = { "*.toml", "*.yaml", "*.yml", "*.json", "*.jsonc" },
})

-- only use number in insert mode (not relativenumber) if number option is set
vim.api.nvim_create_autocmd("InsertEnter", {
  callback = function()
    if vim.wo.number then
      vim.wo.number = true
      vim.wo.relativenumber = false
    end
  end,
  group = config,
  pattern = "*",
})
vim.api.nvim_create_autocmd("InsertLeave", {
  callback = function()
    if vim.wo.number then
      vim.wo.number = true
      vim.wo.relativenumber = true
    end
  end,
  group = config,
  pattern = "*",
})

-- quarto preview file
vim.api.nvim_create_autocmd("FileType", {
  callback = function()
    vim.keymap.set("n", "<localleader>qp", [[<cmd>lua require("config.utils").quarto_preview()<cr>]], {
      noremap = true,
      silent = true,
      desc = "Quarto preview file",
    })
  end,
  group = config,
  pattern = { "markdown", "quarto", "rmd" },
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
  group = config,
})

vim.api.nvim_create_autocmd("UILeave", {
  callback = function()
    if modified then
      io.write("\027]111\027\\")
    end
  end,
  group = config,
})

-- fix conceallevel for json files
vim.api.nvim_create_autocmd({ "FileType" }, {
  callback = function()
    vim.wo.conceallevel = 0
  end,
  group = config,
  pattern = { "json", "jsonc" },
})

-- make it easier to close man-files when opened inline
vim.api.nvim_create_autocmd("FileType", {
  callback = function(event)
    vim.bo[event.buf].buflisted = false
  end,
  group = config,
  pattern = { "man" },
})

vim.api.nvim_create_autocmd("BufWinEnter", {
  callback = function()
    local ft = vim.bo.filetype
    if ft == "dap-repl" or ft:match("^dapui_") then
      vim.wo.statuscolumn = ""
    end
  end,
  group = config,
})

-- r, rmd, markdown, quarto specific keymaps in insert mode
vim.api.nvim_create_autocmd("FileType", {
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.schedule(function()
      vim.keymap.set("i", "<>", "<- ", {
        noremap = true,
        buffer = event.buf,
        silent = true,
        desc = "Replace <> with <- in R, Rmarkdown, markdown, quarto files (insert mode)",
      })

      vim.keymap.set("i", ">>", "%>%<space>", {
        noremap = true,
        buffer = event.buf,
        silent = true,
        desc = "Replace >> with %>% in R, Rmarkdown, markdown, quarto files (insert mode)",
      })
    end)
  end,
  group = config,
  pattern = {
    "r",
    "rmd",
    "markdown",
    "quarto",
  },
})

-- better formatoptions: always override changes made by filetype plugins
vim.api.nvim_create_autocmd("FileType", {
  command = [[setlocal formatoptions-=cro]],
  group = config,
  pattern = "*",
})
