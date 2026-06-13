-- Description: project specific configuration

-- 1. Create .nvim.lua file in project root with the following content:
-- vim.cmd([[set runtimepath+=.nvim]])
-- 2. Create folder structure .nvim/plugin in project root:
-- root/.nvim/plugin
-- 3. Create .nvim/plugin/project.lua file with project specific configuration
-- root/.nvim/plugin/project.lua

-- project.lua template file below

-- set environment variables
-- vim.env.VIRTUAL_ENV = "/path/to/virtual_environment/.venv"

-- LSP configuration (use project specific names with inline configuration)
-- vim.lsp.config("project-lspname", {
--   ...
-- })
-- vim.lsp.enable("project-lspname", true)
-- vim.lsp.enable("lspname-to-disable", false)

-- formatting
local exists_conform, conform = pcall(require, "conform")
if exists_conform then
  conform.setup({
    formatters_by_ft = {
      python = { "ruff_fix", "ruff_format" },
    },
    format_on_save = {
      lsp_fallback = true,
    },
  })
end

-- debugging
local exists_dap, dap = pcall(require, "dap")
if exists_dap then
  dap.configurations.python = {
    {
      type = "debugpy",
      request = "launch",
      name = "Debug/launch current file",
      -- always initiate the debugger from main `program`
      program = "name_of_main_runner.py",
      console = "internalConsole",
      justMyCode = false,
      subProcess = false,
      cwd = "${workspaceFolder}",
      pythonPath = function()
        return Config.utils.get_python_path()
      end,
      stopOnEntry = false,
    },
  }

  -- hook when repl opens: improve default printing of pandas dataframes
  dap.listeners.after.event_initialized["pandas_repl"] = function()
    dap.repl.execute([[

            import pandas as pd
            pd.set_option("display.max_rows", 100)
            pd.set_option("display.max_columns", None)
            pd.set_option("display.width", 1000)
            pd.set_option("display.max_colwidth", 100)
            pd.set_option("display.expand_frame_repr", False)

        ]])
  end
end

-- load last session (incl. restore cursor position, see sessionoptions)
local exists_persistence, persistence = pcall(require, "persistence")
if exists_persistence then
  if vim.fn.argc() == 0 then
    persistence.load()
  else
    persistence.stop()
  end
end

-- git diff from a specific `base`
local exists_snacks, snacks = pcall(require, "snacks")
if exists_snacks then
  vim.keymap.set("n", "<leader>gd", function()
    snacks.picker.git_diff({
      group = false,
      -- SHA commit/branch/tag to diff against
      -- base = "",
      win = {
        input = {
          keys = {
            ["<tab>"] = { "git_stage", mode = { "n", "i" } },
            ["<c-r>"] = false,
          },
        },
      },
    })
  end, {
    noremap = true,
    silent = true,
    desc = "Show git diff",
  })
end
