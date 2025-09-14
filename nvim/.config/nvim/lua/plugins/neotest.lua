-- neotest
return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    -- "antoinemadec/FixCursorHold.nvim", -- might not be needed in the future, see https://github.com/nvim-neotest/neotest
    { "nvim-treesitter/nvim-treesitter", branch = "main" }, -- each test adapter also requires a filetype specific TS parser to be installed
    -- adapters
    "nvim-neotest/neotest-python",
    "shunsambongi/neotest-testthat",
  },
  config = function()
    require("neotest").setup({
      icons = {
        running_animated = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" },
      },
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
            return utils.get_python_path()
          end,
        }),
        require("neotest-testthat"),
      },
      summary = {
        mappings = {
          expand = { "o" },
          help = { "<c-/>" },
        },
      },
    })
  end,
  keys = {
    {
      "<leader>tf",
      [[<cmd>lua require("neotest").run.run(vim.fn.expand("%"))<cr>]],
      mode = "n",
      desc = "Run tests for the current file",
      noremap = true,
      silent = true,
    },
    {
      "<leader>tn",
      [[<cmd>lua require("neotest").run.run()<cr>]],
      mode = "n",
      desc = "Run the nearest test",
      noremap = true,
      silent = true,
    },
    {
      "<leader>td",
      [[<cmd>lua require("neotest").run.run({strategy = "dap"})<cr>]],
      mode = "n",
      desc = "Debug the nearest test",
      noremap = true,
      silent = true,
    },
    {
      "<leader>tq",
      [[<cmd>lua require("neotest").run.stop()<cr>]],
      mode = "n",
      desc = "Stop the nearest test",
      noremap = true,
      silent = true,
    },
    {
      "<leader>tt",
      [[<cmd>lua require("neotest").summary.toggle()<cr>]],
      mode = "n",
      desc = "Toggle the neotest summary window",
      noremap = true,
      silent = true,
    },
  },
}
