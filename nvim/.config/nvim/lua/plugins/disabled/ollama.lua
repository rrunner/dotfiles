return {
  "nomnivore/ollama.nvim",
  enabled = false,
  cond = vim.fn.executable("ollama") == 1,
  opts = {},
  dependencies = {
    "nvim-lua/plenary.nvim",
  },

  -- user commands added by the plugin (lazy load)
  cmd = { "Ollama", "OllamaModel", "OllamaServe", "OllamaServeStop" },

  init = function()
    vim.keymap.set(
      { "n", "v" },
      "<localleader>o",
      ":<c-u>lua require('ollama').prompt()<cr>",
      { noremap = true, desc = "Ollama prompt" }
    )
  end,
}
