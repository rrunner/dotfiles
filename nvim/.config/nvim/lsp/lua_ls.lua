local utils = require("config.utils")

local root_markers1 = {
  ".emmyrc.json",
  ".luarc.json",
  ".luarc.jsonc",
}
local root_markers2 = {
  ".luacheckrc",
  ".stylua.toml",
  "stylua.toml",
  "selene.toml",
  "selene.yml",
}

return {
  cmd = { utils.app_prio("lua-language-server") },
  root_markers = { root_markers1, root_markers2, { ".git" } },
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
        },
      },
      diagnostics = {
        disable = { "missing-fields" },
      },
      telemetry = {
        enable = false,
      },
      codeLens = {
        enable = true,
      },
      hint = {
        enable = true,
        semicolon = "Disable",
        setType = true,
        arrayIndex = "Disable",
      },
      completion = {
        callSnippet = "Replace",
      },
    },
  },
}
