-- quarto

-- linux:
-- install quarto using the package manager
-- in the virtual environment; do install jupyter at minimum but probably also pandas, numpy, and matplotlib
-- wsl:
-- install quarto on wsl (wget the debian package and sudo install the package)
-- in the virtual environment; do install jupyter at minimum but probably also pandas, numpy, and matplotlib
-- may need to use command tabnext to access the localhost link, click on the link (ctrl + leftmousebutton) to open the document in the browser on windows
return {
  "quarto-dev/quarto-nvim",
  ft = "quarto",
  dependencies = {
    "neovim/nvim-lspconfig",
    {
      "jmbuhr/otter.nvim",
      opts = {
        buffers = {
          set_filetype = true,
        },
        handle_leading_whitespace = true,
      },
    },
  },
  config = function()
    local langs = { "r", "python" }

    local opts = {
      lspFeatures = {
        enabled = true,
        languages = langs,
        diagnostics = {
          enabled = false,
          triggers = { "BufWritePost" },
        },
        completion = {
          enabled = true,
        },
      },
    }

    require("quarto").setup(opts)
    require("otter").activate(langs)

    vim.keymap.set("n", "<localleader>qp", [[<cmd>lua require('quarto').quartoPreview()<cr>]], {
      noremap = true,
      silent = true,
      desc = "Quarto preview",
    })

    vim.keymap.set("n", "<localleader>qc", [[<cmd>lua require('quarto').quartoClosePreview()<cr>]], {
      noremap = true,
      silent = true,
      desc = "Quarto close preview",
    })

    -- otter plugin sets keybindings which cannot be disabled in plugin settings
    local remove_otter_keybind = vim.api.nvim_create_augroup("Plugin", { clear = true })
    vim.api.nvim_create_autocmd("FileType", {
      callback = function()
        vim.keymap.del(
          "n",
          "<leader>lR",
          { noremap = true, silent = true, buffer = true, desc = "Unset otter keybind" }
        )
        vim.keymap.del(
          "n",
          "<leader>lf",
          { noremap = true, silent = true, buffer = true, desc = "Unset otter keybind" }
        )
        vim.keymap.del("n", "gD", { noremap = true, silent = true, buffer = true, desc = "Unset otter keybind" })
        vim.keymap.del("n", "gS", { noremap = true, silent = true, buffer = true, desc = "Unset otter keybind" })
      end,
      group = remove_otter_keybind,
      pattern = "quarto",
      once = true,
    })
  end,
}
