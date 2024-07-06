-- project
return {
  "ahmedkhalf/project.nvim",
  config = function()
    require("project_nvim").setup({
      -- patterns used to detect root dir
      patterns = { ".git", "Pipfile", "venv", ".venv", "pyproject.toml" },
      -- silent message when project.nvim changes the root dir
      silent_chdir = true,
    })

    local telescope_exists, telescope = pcall(require, "telescope")
    if telescope_exists then
      telescope.load_extension("projects")
    end
  end,
  init = function()
    vim.api.nvim_set_keymap("n", "<leader>sp", [[<cmd>Telescope projects<cr>]], {
      noremap = true,
      silent = true,
      desc = "Search projects",
    })
  end,
}
