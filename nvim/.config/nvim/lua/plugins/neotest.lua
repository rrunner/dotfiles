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
  ft = { "python", "r" },
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
            local utils = require("config.utils")
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

    vim.keymap.set("n", "<leader>tf",
      function()
        require("neotest").run.run(vim.fn.expand("%"))
      end,
      {
        noremap = true,
        silent = true,
        desc = "Run tests for the current file",
      })

    vim.keymap.set("n", "<leader>tn",
      function()
        require("neotest").run.run()
      end,
      {
        noremap = true,
        silent = true,
        desc = "Run the nearest test",
      })

    vim.keymap.set("n", "<leader>td",
      function()
        require("neotest").run.run({ strategy = "dap" })
      end,
      {
        noremap = true,
        silent = true,
        desc = "Debug the nearest test",
      })

    vim.keymap.set("n", "<leader>tt",
      function()
        require("neotest").summary.toggle()
      end,
      {
        noremap = true,
        silent = true,
        desc = "Toggle the neotest summary window",
      })
  end,
}
