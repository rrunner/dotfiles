-- project specific configuration template

-- set environment variables
-- vim.env.VIRTUAL_ENV = "/path/to/virtual_environment/.venv"

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
      program = "${file}",
      console = "internalConsole",
      justMyCode = false,
      subProcess = false,
      cwd = "${workspaceFolder}",
      pythonPath = function()
        return utils.get_python_path()
      end,
      stopOnEntry = false,
    },
  }
end

-- load last session
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
