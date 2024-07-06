local utils = require("config.utils")

local uv = vim.uv

vim.api.nvim_create_user_command("Cwd", function()
  local _cwd = uv.cwd()
  local cur_file_name = vim.api.nvim_buf_get_name(0)
  if utils.is_non_normal_buffer() then
    return
  end
  local cur_parent_dir = vim.fn.fnamemodify(cur_file_name, ":h")
  if cur_parent_dir ~= _cwd then
    vim.api.nvim_set_current_dir(cur_parent_dir)
    vim.notify("Changed cwd to: " .. uv.cwd(), vim.log.levels.INFO)
  end
end, { desc = "Change cwd to the current file's parent folder" })
