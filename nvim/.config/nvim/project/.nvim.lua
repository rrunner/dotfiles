-- project specific configuration template

-- set environment variables
-- vim.env.VIRTUAL_ENV = "/path/to/virtual_environment/.venv"

-- formatting
require("conform").setup({
  formatters_by_ft = {
    python = { "ruff_fix", "ruff_format" },
  },
  format_on_save = {
    lsp_fallback = true,
  },
})

-- debugging
require("dap").configurations.python = {
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

-- load last session
if vim.fn.argc() == 0 then
  require("persistence").load()
else
  require("persistence").stop()
end

-- git diff from a specific `base`
vim.keymap.set("n", "<leader>gd", function()
  require("snacks").picker.git_diff({
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
