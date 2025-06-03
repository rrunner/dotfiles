local utils = require("config.utils")

vim.api.nvim_create_user_command("Cwd", function()
  local _cwd = vim.uv.cwd()
  local cur_file_name = vim.api.nvim_buf_get_name(0)
  if utils.is_non_normal_buffer() then
    return
  end
  local cur_parent_dir = vim.fn.fnamemodify(cur_file_name, ":h")
  if cur_parent_dir ~= _cwd then
    vim.api.nvim_set_current_dir(cur_parent_dir)
    vim.notify("Changed cwd to: " .. vim.uv.cwd(), vim.log.levels.INFO)
  end
end, { desc = "Change cwd to the current file's parent folder" })

vim.api.nvim_create_user_command("ToggleLSP", function()
  local clients = vim.lsp.get_clients()
  if next(clients) then
    vim.notify("Stop all LSP clients in buffer", vim.log.levels.INFO)
    vim.lsp.stop_client(clients)
  else
    -- client is an empty table
    vim.notify("Start all LSP clients in buffer", vim.log.levels.INFO)
    vim.cmd("edit!")
  end
end, { desc = "Toggle LSP on/off for the current buffer" })

-- vim.api.nvim_create_user_command("CommitLazyLockFile", function()
--   local repo_dir = vim.env.HOME .. "/dotfiles"
--   local lockfile = repo_dir .. "/nvim/.config/nvim/lazy-lock.json"
--
--   local cmd = {
--     "git",
--     "-C",
--     repo_dir,
--     "commit",
--     lockfile,
--     "-m",
--     "Update lazy-lock.json",
--   }
--
--   local success, process = pcall(function()
--     return vim.system(cmd):wait()
--   end)
--
--   if process and process.code == 0 then
--     vim.notify("Committed lazy-lock.json")
--     vim.notify(process.stdout)
--   else
--     if not success then
--       vim.notify("Failed to run command '" .. table.concat(cmd, " ") .. "':", vim.log.levels.WARN, {})
--       vim.notify(tostring(process), vim.log.levels.WARN, {})
--     else
--       vim.notify("git ran but failed to commit:")
--       vim.notify(process.stdout, vim.log.levels.WARN, {})
--     end
--   end
-- end, { desc = "git commit lockfile lazy-lock.json (lazy package manager)" })
