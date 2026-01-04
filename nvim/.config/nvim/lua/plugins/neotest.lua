-- neotest
return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    -- adapters
    "nvim-neotest/neotest-python",
    "jfpedroza/neotest-elixir",
  },
  ft = { "python", "r", "elixir" },
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

    vim.keymap.set("n", "<leader>tq", function()
      if vim.bo.filetype == "python" then
        require("dap").toggle_breakpoint()
        require("neotest").run.run({ strategy = "dap" })
      else
        vim.notify("Debugging test not configured", "warn")
      end
    end, {
      noremap = true,
      silent = true,
      desc = "Quicker debug the nearest test (set breakpoint and run)",
    })

    vim.keymap.set("n", "<leader>td", function()
      if vim.bo.filetype == "python" then
        require("neotest").run.run({ strategy = "dap" })
      else
        vim.notify("Debugging test not configured", "warn")
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
  end,
}
