--utility functions
local M = {}

local str = require("string")

local uv = vim.uv

-- detect OS
local OS_SYSTEM = uv.os_uname().sysname
M.IS_LINUX = str.lower(OS_SYSTEM):find("linux") and true or false
M.IS_WIN = str.lower(OS_SYSTEM):find("windows") and true or false
M.IS_WSL = (function()
  local output = vim.fn.systemlist("uname -r")
  if output ~= nil then
    return not not str.find(output[1] or "", "WSL")
  end
  vim.notify("Issue to identify WSL system", vim.log.levels.ERROR)
  return nil
end)()

-- path separator
local path_sep = function()
  if M.IS_WIN then
    return "\\"
  else
    return "/"
  end
end

-- telescope_live_grep_in_path (has keybinding <leader>sg):
-- user provides a path for the search (defaults to cwd)
M.telescope_live_grep_in_path = function()
  vim.ui.input({
    prompt = "Enter directory (cwd):",
    completion = "dir",
    default = uv.cwd() .. path_sep(),
  }, function(input)
    if input == nil then
      -- window is closed with a keybind
      return
    elseif input and vim.fn.isdirectory(input) ~= 0 then
      require("telescope.builtin").live_grep({ search_dirs = { input } })
    else
      vim.notify("No valid directory")
    end
  end)
end

-- user_provide_path (local function)
-- user provides a path for the search (defaults to cwd)
local user_provide_path = function(callback)
  vim.ui.input({
    prompt = "Enter directory (cwd):",
    completion = "dir",
    default = uv.cwd() .. path_sep(),
  }, function(input)
    if input == nil then
      -- window is closed with a keybind
      return
    elseif input and vim.fn.isdirectory(input) ~= 0 then
      callback({ hidden = true, search_dirs = { input } })
    else
      vim.notify("No valid directory")
    end
  end)
end

-- telescope_files_or_git_files (has keybinding <leader>sf):
-- find files, or git files in .git directory
M.telescope_files_or_git_files = function()
  local utl = require("telescope.utils")
  local builtin = require("telescope.builtin")
  local _, ret, _ = utl.get_os_command_output({ "git", "rev-parse", "--is-inside-work-tree" })
  if ret == 0 then
    builtin.git_files()
  else
    user_provide_path(require("telescope.builtin").find_files)
  end
end

-- telescope_live_grep_args (has keybinding <leader>sa)
-- ripgrep with arguments
M.telescope_live_grep_args = function()
  user_provide_path(require("telescope").extensions.live_grep_args.live_grep_args)
end

-- note taking using quarto (select folder where notes are stored)
local detect_notes_folder = function()
  local notes_folder
  notes_folder = vim.fn.stdpath("config") .. "/templates"
  if vim.fn.isdirectory(notes_folder) ~= 0 then
    return notes_folder
  end
  ---@diagnostic disable-next-line: param-type-mismatch
  vim.notify("Notes folder is not configured. See utils.lua file", vim.log.levels.WARN)
  return nil
end

-- search for existing notes or start from any template
M.search_notes = function()
  local notes_folder = detect_notes_folder()
  if notes_folder ~= nil then
    vim.cmd(str.format("silent lcd %s", vim.env.HOME))
    require("telescope.builtin").find_files({ search_dirs = { notes_folder } })
  end
end

-- retrieve the path to the active python interpreter based on environment
-- variables VIRTUAL_ENV (incl. pyenv virtual envs), CONDA_PREFIX or system
-- interpreter
---@return string  -- the path to the active python interpreter, returns empty string if no python interpreter is found
M.get_python_path = function()
  local venv_path = os.getenv("VIRTUAL_ENV")
  if venv_path then
    if M.IS_WIN then
      local bin_path = venv_path .. "\\Scripts\\python.exe"
      vim.notify("python executable (venv)", vim.log.levels.INFO)
      return bin_path
    end

    local bin_path = venv_path .. "/bin/python"

    if string.match(bin_path, ".pyenv") then
      -- pyenv virtual environment
      vim.notify("python executable (pyenv venv)", vim.log.levels.INFO)
    else
      -- regular virtual environment
      vim.notify("python executable (venv)", vim.log.levels.INFO)
    end
    return bin_path
  end

  local conda_path = os.getenv("CONDA_PREFIX")
  if conda_path then
    if M.IS_WIN then
      local bin_path = conda_path .. "\\python.exe"
      vim.notify("python executable (conda)", vim.log.levels.INFO)
      return bin_path
    end

    local bin_path = conda_path .. "/bin/python"
    vim.notify("python executable (conda)", vim.log.levels.INFO)
    return bin_path
  end

  if vim.fn.executable("python") then
    local bin_path = vim.fn.exepath("python")
    vim.notify("python executable (system)", vim.log.levels.INFO)
    return bin_path
  end

  vim.notify("python executable not found", vim.log.levels.WARN)
  return ""
end

-- retrieve the path to the python debugger (debugpy). Mason is prioritized.
-- Mason picks the virtual python binary (or pyenv python binary) if the
-- virtual environment is active, otherwise defaults to use the python system
-- binary which thus requires the debugpy python package to be installed on the
-- system
---@return string  -- the path to python debugger (debugpy), returns empty string if no python debugger is found
M.get_debugpy_path = function()
  local do_notify = true

  if M.IS_WIN then
    vim.notify("debugpy not yet configured on Windows", vim.log.levels.WARN)
    return ""
  end

  local mason_path = vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python"

  if vim.fn.executable(mason_path) == 1 then
    if do_notify then
      vim.notify("use debugpy (mason)", vim.log.levels.INFO)
    end
    return mason_path
  end

  if vim.fn.executable("python") == 1 then
    if do_notify then
      vim.notify("use debugpy (system)", vim.log.levels.INFO)
    end
    return "python"
  end

  vim.notify("debugpy not configured", vim.log.levels.WARN)
  return ""
end

-- retrieve current working directory (cwd) prefixed with 'a snake' followed by
-- the name of the Python virtual environment if this is active (consumed by
-- the lualine plugin)
---@return string  -- the cwd possibly prefixed with name of Python virtual environment
M.venv_with_cwd = function()
  local venv = vim.env.VIRTUAL_ENV or nil
  if venv == nil then
    return uv.cwd() or ""
  end
  return "󱔎 (" .. str.match(venv, "/?([%w_-]+)$") .. ") " .. uv.cwd()
end

-- daily vim tip from vtip.43z.one
M.tip = function()
  local job = require("plenary.job")
  job
    :new({
      command = "curl",
      args = { "https://vtip.43z.one" },
      on_exit = function(j, exit_code)
        local res = table.concat(j:result())
        if exit_code ~= 0 then
          res = "Error fetching tip: " .. res
        end
        require("notify")(res)
      end,
    })
    :start()
end

-- move to window if the buffer is already visible in a window (consumed in
-- telescope via <cr> upon <c-tab> to display buffers)
---@return nil  -- nil
M.open_buffer = function(prompt_bufnr)
  local entry = require("telescope.actions.state").get_selected_entry(prompt_bufnr)
  if not entry then
    return
  end

  local buffer_number = entry.bufnr
  for _, window in ipairs(vim.api.nvim_list_wins()) do
    if vim.api.nvim_win_get_buf(window) == buffer_number then
      -- move to window if the selected buffer is already visible
      vim.api.nvim_set_current_win(window)
      return
    end
  end

  -- close telescope window
  require("telescope.actions").close(prompt_bufnr)

  -- display the selected buffer in the current window
  vim.api.nvim_win_set_buf(0, buffer_number)
end

-- function to remove a table item by value, the input_table should be a
-- simple table in the form of a list/array
---@param input_table table  -- table input list/array to mutate
---@param items_remove table  -- table of items to be removed (by name)
---@return nil  -- nil
M.remove_value = function(input_table, items_remove)
  if next(items_remove) == nil then
    return nil
  end
  for i = #input_table, 1, -1 do
    if vim.tbl_contains(items_remove, input_table[i]) then
      table.remove(input_table, i)
    end
  end
  return nil
end

-- function to create a table with the unique keys from two tables
---@param list1 table  -- table 1
---@param list2 table  -- table 2
---@return table
M.unique_values = function(list1, list2)
  local result = {}
  for _, lst in pairs({ list1, list2 }) do
    for _, val in ipairs(lst) do
      if not vim.tbl_contains(result, val) then
        table.insert(result, val)
      end
    end
  end
  return result
end

-- function to retrieve all buffer names in open windows
---@return table -- a table containing the names of all loaded buffers having a name
M.all_buffer_names_in_open_win = function()
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
  local buffer_names = M.all_buffer_names_in_open_win()
  local dapui_filetypes = {
    "dapui_scopes",
    "dapui_breakpoints",
    "dapui_stacks",
    "dapui_watches",
    "dapui_console",
    "dap-repl",
  }
  for _, buffer_name in ipairs(buffer_names) do
    if vim.tbl_contains(dapui_filetypes, buffer_name) then
      return true
    end
  end
  -- -- alternative solution: however, it loads the dap plugin when neotree/zen mode is activated
  -- local exist_dap, dap = pcall(require, "dap")
  -- if exist_dap and dap.session() then
  --   return true
  -- end
  -- return false
  return false
end

-- function to identify if the the current buffer is 'non-normal',
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

return M
