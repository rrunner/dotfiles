-- utility functions
local M = {}

local str = require("string")

-- set OS flags
local OS_SYSTEM = vim.uv.os_uname().sysname
M.IS_LINUX = OS_SYSTEM == "Linux"
M.IS_WIN = OS_SYSTEM == "Windows_NT"
M.IS_WSL = (function()
  local output = vim.fn.systemlist("uname -r")
  if vim.v.shell_error ~= 0 then
    vim.notify("Issue identifying WSL system", vim.log.levels.ERROR)
    return false
  end
  return output[1] and output[1]:find("WSL", 1, true) ~= nil
end)()

-- The path separator used on the system
---@type string -- path separator
M.path_sep = package.config:sub(1, 1)

M.inside_git_repo = function()
  local _ = vim.fn.system("git rev-parse --is-inside-work-tree")
  return vim.v.shell_error == 0
end

--- Retrieves the path to the Python interpreter for debugging. First checks
--- VIRTUAL_ENV for a local installation, then falls back to system Python.
--- Also validates if debugpy is found in the virtual environment.
---@return string -- path to the active Python interpreter (empty string if not found)
M.get_python_path = function()
  local py_path

  if vim.env.VIRTUAL_ENV then
    local dpath = vim.env.VIRTUAL_ENV .. "/bin/debugpy"
    if vim.fn.executable(dpath) == 0 then
      vim.notify("debugpy is not found in virtual environment", vim.log.levels.WARN)
    end

    py_path = vim.env.VIRTUAL_ENV .. "/bin/python"
    if vim.fn.executable(py_path) ~= 0 then
      return py_path
    end
    vim.notify("python is not found in virtual environment", vim.log.levels.WARN)
  end

  -- checks for system installation of python
  py_path = vim.fn.exepath("python3") or vim.fn.exepath("python")
  if py_path == "" then
    vim.notify("python is not found in system", vim.log.levels.WARN)
  end
  return py_path
end

-- set the priority order for a given application's binary package. Binaries
-- provided by the virtual environment (if python_tool = true) is prioritized
-- over Mason and system provided binaries.
---@param app string  -- the name of the application binary
---@param opts? { python_tool?: boolean }  -- optional options table
---@return string  -- the path to the app binary
M.app_prio = function(app, opts)
  opts = opts or {}
  local debug = false
  local application

  if opts.python_tool then
    local venv = vim.env.VIRTUAL_ENV or nil
    if venv then
      application = venv .. "/bin/" .. app

      -- application is available as a package binary inside the virtual environment
      if vim.fn.executable(application) == 1 then
        if debug then
          vim.notify(application, vim.log.INFO)
        end
        return application
      end
    end
  end

  -- application is available as a Mason package binary
  application = vim.fn.stdpath("data") .. "/mason/bin/" .. app
  if vim.fn.executable(application) == 1 then
    if debug then
      vim.notify(application, vim.log.INFO)
    end
    return application
  end

  -- application is available as a system binary
  if vim.fn.executable(app) == 1 then
    if debug then
      vim.notify(application, vim.log.INFO)
    end
    return app
  end
  return ""
end

-- retrieve current working directory (cwd) prefixed with 'a snake' followed by
-- the name of the Python virtual environment if this is active (consumed by
-- the statusline plugin)
---@return string  -- the cwd possibly prefixed with name of Python virtual environment
M.venv_with_cwd = function()
  local venv = vim.env.VIRTUAL_ENV or nil
  if venv == nil then
    return vim.uv.cwd() or ""
  else
    return Config.icons.extra.python_no_color .. " (" .. str.match(venv, "/?([.%w_-]+)$") .. ") " .. vim.uv.cwd()
  end
end

-- function to create a table with the unique keys from two list-like tables
---@param list1 table  -- list-like table 1
---@param list2 table  -- list-like table 2
---@return table
M.unique_values = function(list1, list2)
  vim.list_extend(list1, list2) -- mutates list1
  return vim.list.unique(list1)
end

-- function to retrieve all buffer filetypes in the window
---@return table -- a table containing the buffer filetypes in the window
M.all_buffer_filetypes_in_win = function()
  local buffer_names = {}

  -- iterate through all open windows
  for _, winid in ipairs(vim.api.nvim_list_wins()) do
    local bufnr = vim.api.nvim_win_get_buf(winid)
    if vim.api.nvim_buf_is_loaded(bufnr) then
      table.insert(buffer_names, vim.bo[bufnr].filetype)
    end
  end
  return buffer_names
end

-- function to identify if there is debugger session (DAP) running
---@return boolean -- true if DAP is running, false otherwise
M.is_debugger_running = function()
  local buffer_filetypes = M.all_buffer_filetypes_in_win()
  local dapui_filetypes = {
    "dapui_scopes",
    "dapui_breakpoints",
    "dapui_stacks",
    "dapui_watches",
    "dapui_console",
    "dap-repl",
  }
  for _, buffer_ft in ipairs(buffer_filetypes) do
    if vim.tbl_contains(dapui_filetypes, buffer_ft) then
      return true
    end
  end
  return false
end

-- function to close Snacks explorer pickers
---@return nil
M.close_explorer_picker = function()
  local exists_snacks, snacks = pcall(require, "snacks")
  if not exists_snacks then
    return
  end
  -- get all active explorer pickers
  local exp = snacks.picker.get({ source = "explorer" })
  for _, picker in ipairs(exp) do
    picker:close()
  end
end

-- function to identify if the current buffer is 'non-normal',
-- a buffer is 'non-normal' if it is floating, unnamed or does have
-- a buftype defined
---@return boolean -- true if buffer is 'non-normal', false otherwise
M.is_non_normal_buffer = function()
  local is_float_win = vim.api.nvim_win_get_config(0).relative ~= ""
  local is_unnamed_buffer = vim.api.nvim_buf_get_name(0) == ""
  local is_non_normal_buffer = vim.bo[0].buftype ~= ""

  if is_float_win or is_unnamed_buffer or is_non_normal_buffer then
    return true
  end
  return false
end

M.quarto_preview = function(opts)
  opts = opts or {}
  local args = opts.args or ""

  local buffer_path = vim.api.nvim_buf_get_name(0)
  local cmd = "quarto preview '" .. buffer_path .. "'" .. " " .. args

  local quarto_extensions = { ".qmd", ".Rmd", ".ipynb", ".md" }
  local file_extension = buffer_path:match("^.+(%..+)$")
  if not vim.tbl_contains(quarto_extensions, file_extension) then
    vim.notify("Not a quarto, rmarkdown, Jupyter notebook or markdown file. Exiting.")
    return
  end

  -- run command in embedded terminal (in a new tab and go back to the buffer)
  vim.cmd("tabedit term://" .. cmd)
  vim.cmd("tabprevious")
end

M.get_filetype_icon = function(filetype)
  local exists, mini_icons = pcall(require, "mini.icons")
  if not exists then
    return ""
  end
  local icon, hl_group, _ = mini_icons.get("filetype", filetype)
  return icon and "%#" .. hl_group .. "#" .. icon .. "%* " or ""
end

-- function to identify if the current buffer is a Snacks scratch buffer
---@param buf integer  -- buffer number
---@return boolean -- true if the current buffer is a Snacks scratch buffer
M.inside_scratch_buffer = function(buf)
  local exists_snacks, snacks = pcall(require, "snacks")
  if not exists_snacks then
    return false
  end
  local file = vim.api.nvim_buf_get_name(buf)
  return vim.iter(snacks.scratch.list()):find(function(s)
    return s.file == file
  end)
end

-- evaluate callback without snacks scroll
M.run_wo_snacks_scroll = function(callback)
  local snacks_exist, snacks = pcall(require, "snacks")
  if snacks_exist then
    snacks.scroll.disable()
  end
  callback()
  if snacks_exist then
    snacks.scroll.enable()
  end
end

M.schema_settings = function(schematype)
  if vim.g.is_github_not_blocked then
    local exists, schemastore = pcall(require, "schemastore")
    if not exists then
      return {}
    end
    return schemastore[schematype].schemas()
  else
    return {}
  end
end

Config.utils = M
