-- autocommands
local config = vim.api.nvim_create_augroup("Config", { clear = true })

vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    (vim.hl or vim.highlight).on_yank({ timeout = 700 })
  end,
  group = config,
  pattern = "*",
  desc = "Highlight on yank",
})

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
  desc = "Set terminal settings on open",
})

vim.api.nvim_create_autocmd("TermClose", {
  callback = function()
    if vim.v.event.status == 0 then
      vim.api.nvim_buf_delete(0, {})
    end
  end,
  group = config,
  pattern = "*",
  desc = "Auto-close terminal when process exits",
})

vim.api.nvim_create_autocmd("FileType", {
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", function()
      if #vim.api.nvim_list_wins() == 1 then
        vim.cmd("bdelete")
      else
        vim.cmd("close")
      end
    end, {
      noremap = true,
      silent = true,
      buf = event.buf,
      desc = "Close buffer or window with q",
    })
  end,
  group = config,
  pattern = {
    "checkhealth",
    "diff",
    "git",
    "gitsigns-blame",
    "help",
    "man",
    "neotest-output",
    "neotest-summary",
    "nvim-pack",
    "nvim-undotree",
    "qf",
    "query",
  },
  desc = "Close specific filetypes with q",
})

vim.api.nvim_create_autocmd("CmdwinEnter", {
  callback = function()
    vim.keymap.set("n", "q", function()
      vim.cmd.close()
    end, {
      buf = 0,
      remap = false,
      silent = true,
    })
  end,
  group = config,
  pattern = "*",
  desc = "Close command-line window (q:, q/ and q? etc.) with q",
})

-- make autoread work as expected on Windows OS
if Config.utils.IS_WIN then
  vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "CursorHoldI", "FocusGained" }, {
    command = [[if mode() != 'c' | checktime | endif]],
    group = config,
    pattern = "*",
    desc = "Auto-reload files when modified externally",
  })
else
  -- maybe this can replace the autocmd for win above
  vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
    callback = function()
      if vim.o.buftype ~= "nofile" then
        vim.cmd("checktime")
      end
    end,
    group = config,
    pattern = "*",
    desc = "Reload the file when it changed",
  })
end

vim.api.nvim_create_autocmd({ "BufWinEnter", "BufFilePost", "WinEnter" }, {
  callback = function(event)
    -- set winbar for these file types (global winbar option must be set to the empty string)
    local ft_with_winbar = {
      "elixir",
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
    if Config.utils.is_non_normal_buffer() or not vim.tbl_contains(ft_with_winbar, ft) then
      vim.wo[winid][0].winbar = ""
      return
    end

    vim.wo[winid][0].winbar = "%=" .. Config.utils.get_filetype_icon(ft) .. "%m%r%{expand('%:p:h:t')}/%t"
  end,
  group = config,
  pattern = "*",
  desc = "Set/unset winbar",
})

vim.api.nvim_create_autocmd({ "InsertLeave", "WinEnter" }, {
  callback = function(event)
    local winid = vim.fn.bufwinid(event.buf)
    vim.wo[winid][0].cursorline = true
  end,
  group = config,
  pattern = "*",
  desc = "Display cursor line in active window",
})
vim.api.nvim_create_autocmd({ "InsertEnter", "WinLeave" }, {
  callback = function(event)
    local winid = vim.fn.bufwinid(event.buf)
    vim.wo[winid][0].cursorline = false
  end,
  group = config,
  pattern = "*",
  desc = "Hide cursor line in inactive window",
})

vim.api.nvim_create_autocmd("FileType", {
  callback = function(event)
    local bufnr = event.buf
    local winid = vim.fn.bufwinid(bufnr)
    vim.wo[winid][0].spell = true
    vim.bo[bufnr].spelllang = "en,sv"
    vim.bo[bufnr].spelloptions = "camel"
  end,
  group = config,
  pattern = { "text", "tex", "markdown", "quarto", "rmd", "mail", "plaintex", "gitcommit" },
  desc = "Enable spell checking for certain file types",
})

vim.api.nvim_create_autocmd("FileType", {
  callback = function()
    vim.wo.wrap = true
  end,
  group = config,
  pattern = { "quarto", "rmd", "plaintex", "gitcommit" },
  desc = "Set wrap for certain file types not covered by config in after",
})

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
  desc = "Delete [No Name] buffers",
})

vim.api.nvim_create_autocmd({ "VimResized" }, {
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd("tabdo wincmd =")
    vim.cmd("tabnext " .. current_tab)
  end,
  group = config,
  pattern = "*",
  desc = "Resize splits for each tab if window is resized",
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  command = [[set filetype=mail]],
  group = config,
  pattern = "*.mail",
  desc = "Set filetype for *.mail",
})

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
  desc = "Open file at the last edited position (for configuration files)",
})

vim.api.nvim_create_autocmd("InsertEnter", {
  callback = function()
    if vim.wo.number then
      vim.wo.number = true
      vim.wo.relativenumber = false
    end
  end,
  group = config,
  pattern = "*",
  desc = "Display number in insert mode",
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
  desc = "Display relative number in normal/visual mode",
})

vim.api.nvim_create_autocmd("FileType", {
  callback = function()
    vim.keymap.set("n", "<localleader>qp", function()
      Config.utils.quarto_preview()
    end, {
      noremap = true,
      silent = true,
      desc = "Quarto preview file",
    })
  end,
  group = config,
  pattern = { "markdown", "quarto", "rmd" },
  desc = "Quarto preview file",
})

vim.api.nvim_create_autocmd({ "FileType" }, {
  callback = function()
    vim.wo.conceallevel = 0
  end,
  group = config,
  pattern = { "json", "jsonc" },
  desc = "Fix conceallevel for json files",
})

vim.api.nvim_create_autocmd("FileType", {
  callback = function(event)
    vim.bo[event.buf].buflisted = false
  end,
  group = config,
  pattern = { "man" },
  desc = "Make it easier to close man-files when opened inline",
})

vim.api.nvim_create_autocmd("BufWinEnter", {
  callback = function()
    local ft = vim.bo.filetype
    if ft == "dap-repl" or ft:match("^dapui_") then
      vim.wo.statuscolumn = ""
    end
  end,
  group = config,
  desc = "Unset statuscolumn in DAP buffers",
})

vim.api.nvim_create_autocmd("FileType", {
  callback = function()
    vim.keymap.set("i", "<>", "<- ", {
      noremap = true,
      buf = 0,
      silent = true,
      desc = "Replace <> with <- in R, Rmarkdown, markdown, quarto files (insert mode)",
    })

    vim.keymap.set("i", ">>", "%>%<space>", {
      noremap = true,
      buf = 0,
      silent = true,
      desc = "Replace >> with %>% in R, Rmarkdown, markdown, quarto files (insert mode)",
    })
  end,
  group = config,
  pattern = {
    "r",
    "rmd",
    "markdown",
    "quarto",
  },
  desc = "Set r, rmd, markdown and quarto specific keymaps in insert mode",
})

vim.api.nvim_create_autocmd("FileType", {
  command = [[setlocal formatoptions-=cro]],
  group = config,
  pattern = "*",
  desc = "Always override formatoptions imposed by filetype plugins",
})

vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    local arg = vim.fn.argv()[1]
    if vim.fn.isdirectory(arg) ~= 0 then
      local target = vim.fn.fnameescape(arg)
      vim.cmd("cd " .. target)
    end
  end,
  group = config,
  desc = "Change cwd to the passed directory argument at start",
})
