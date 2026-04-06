-- neotest
vim.pack.add({
  { src = "https://github.com/nvim-neotest/neotest" },
  -- python test adapter
  { src = "https://github.com/nvim-neotest/neotest-python" },
  -- elixir test adapter
  { src = "https://github.com/jfpedroza/neotest-elixir" },
})

require("neotest").setup({
  icons = Config.icons.test,
  adapters = {
    require("neotest-python")({
      -- arguments for nvim-dap configuration
      dap = {
        justMyCode = false,
      },
      -- default test runner
      runner = "pytest",
      -- custom python path for the runner
      python = function()
        return Config.utils.get_python_path()
      end,
    }),
    require("neotest-elixir"),
  },
  summary = {
    mappings = {
      expand = { "o" },
      help = { "<c-/>" },
    },
  },
})

vim.keymap.set("n", "<leader>tf", function()
  require("neotest").run.run(vim.fn.expand("%"))
end, {
  noremap = true,
  silent = true,
  desc = "Run tests for the current file",
})

vim.keymap.set("n", "<leader>tn", function()
  require("neotest").run.run()
end, {
  noremap = true,
  silent = true,
  desc = "Run the nearest test",
})

vim.keymap.set("n", "<leader>td", function()
  if vim.bo.filetype == "python" then
    require("neotest").run.run({ strategy = "dap" })
  else
    vim.notify("Debugging test not configured", vim.log.levels.WARN)
  end
end, {
  noremap = true,
  silent = true,
  desc = "Debug the nearest test",
})

vim.keymap.set("n", "<leader>tt", function()
  require("neotest").summary.toggle()
end, {
  noremap = true,
  silent = true,
  desc = "Toggle the neotest summary window",
})
