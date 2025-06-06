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
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME,
          "${3rd}/luv/library", -- uv modules probably not needed to specify in nvim >= 0.12
          -- vim.api.nvim_get_runtime_file("", true), -- pull in entire rtp (much slower)
        },
      },
      diagnostics = {
        disable = { "missing-fields" },
        globals = { "vim", "utils", "icons", "require" },
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
