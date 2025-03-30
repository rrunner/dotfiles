local utils = require("config.utils")

return {
  cmd = { utils.app_prio("lua-language-server") },
  root_markers = { ".luarc.json" },
  filetypes = { "lua" },
  settings = {
    Lua = {
      runtime = {
        version = "LuaJIT",
      },
      workspace = {
        checkThirdParty = "Disable",
        library = {
          vim.api.nvim_get_runtime_file("", true),
          "${3rd}/luv/library",
        },
      },
      diagnostics = {
        disable = { "missing-fields" },
        globals = { "vim", "utils", "icons" },
      },
      telemetry = {
        enable = false,
      },
      hint = {
        enable = true,
        setType = true,
        arrayIndex = "Disable",
      },
      completion = {
        callSnippet = "Replace",
      },
    },
  },
}
