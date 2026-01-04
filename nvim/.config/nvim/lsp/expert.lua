local utils = require("config.utils")

return {
  cmd = { utils.app_prio("expert"), "--stdio" },
  filetypes = { "elixir", "eelixir", "heex" },
  root_markers = { "mix.exs", ".git" },
}
