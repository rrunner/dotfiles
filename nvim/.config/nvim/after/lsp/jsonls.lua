local schemas = Config.utils.schema_settings("json")

return {
  cmd = function(dispatchers, config)
    local cmd = "vscode-json-language-server"
    if (config or {}).root_dir then
      local local_cmd = vim.fs.joinpath(config.root_dir, "node_modules/.bin", cmd)
      if vim.fn.executable(local_cmd) == 1 then
        cmd = local_cmd
      end
    end
    return vim.lsp.rpc.start({ cmd, "--stdio" }, dispatchers)
  end,
  root_markers = { ".git" },
  filetypes = { "json", "jsonc" },
  init_options = {
    -- use prettier via conform.nvim
    provideFormatter = false,
  },
  settings = {
    json = {
      schemas = schemas,
    },
  },
}
