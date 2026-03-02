return {
  "NickvanDyke/opencode.nvim",
  version = "*",
  dependencies = {
    "folke/snacks.nvim",
  },
  config = function()
    vim.g.opencode_opts = {}

    vim.keymap.set({ "n", "x" }, "<leader>oa", function()
      require("opencode").ask("@this: ", { submit = true })
    end, { desc = "Ask opencode" })

    vim.keymap.set({ "n", "x" }, "<leader>os", function()
      require("opencode").select()
    end, { desc = "Select opencode" })

    vim.keymap.set("n", "<leader>oo", function()
      require("opencode").toggle()
    end, { desc = "Toggle opencode" })
  end,
}
