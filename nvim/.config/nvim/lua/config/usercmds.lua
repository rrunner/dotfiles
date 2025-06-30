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
  if vim.tbl_isempty(clients) then
    vim.notify("Start all LSP clients in buffer", vim.log.levels.INFO)
    vim.cmd("edit!")
  else
    vim.notify("Stop all LSP clients in buffer", vim.log.levels.INFO)
    vim.lsp.stop_client(clients)
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

vim.api.nvim_create_user_command("JsonPath", function()
  if not vim.tbl_contains({ "json" }, vim.bo.filetype) then
    print("filetype is not json")
    return
  end

  local initial_cursor = vim.api.nvim_win_get_cursor(0)

  -- move cursor to the first : sign (assume pretty formatted json document)
  vim.cmd([[normal! 0f:]])

  local start_node = vim.treesitter.get_node()
  if not start_node then
    print("No Treesitter node found under cursor")
    return
  end

  -- get the cursor position, line and column (0-based)
  local cursor = vim.api.nvim_win_get_cursor(0)
  local line_num = cursor[1]
  local col_num = cursor[2] + 1

  -- reset cursor position
  vim.api.nvim_win_set_cursor(0, initial_cursor)

  -- recursive function to build the path
  local function build_path(node, path)
    if not node then
      return path
    end

    local parent = node:parent()
    local node_type = node:type()
    local parent_type = parent and parent:type() or nil

    if node_type == "pair" then
      -- get the key of the pair
      for child in node:iter_children() do
        if child:type() == "string" then
          local key_text = vim.treesitter.get_node_text(child, 0)
          -- remove quotes from string keys
          key_text = key_text:gsub('^"(.*)"$', "%1")
          table.insert(path, 1, key_text)
          break
        end
      end
    elseif node_type == "array" then
      -- skip array indexing
    end

    if parent_type == "document" then
      table.insert(path, 1, "root")
    end

    -- recurse to the parent
    return build_path(parent, path)
  end

  -- build the path recursively
  local path = build_path(start_node, {})

  -- join the path with periods and prepend line:col
  local path_str = table.concat(path, ".")
  local output = string.format("%d:%d:%s", line_num, col_num, " " .. path_str)
  print("JSON path: " .. output)
end, { desc = "Display the json path for the current line" })
