-- lualine
return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local utils = require("config.utils")
    local icons = require("config.icons")

    local opts = {
      options = {
        icons_enabled = true,
        theme = "auto",
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        globalstatus = true,
        disabled_filetypes = {
          statusline = {
            "help",
            "snacks_picker_list",
            "snacks_picker_input",
            "snacks_terminal",
          },
        },
      },
      sections = {
        lualine_a = {
          function()
            return ""
          end,
          -- "mode",
        },
        lualine_b = {
          "branch",
          "diff",
          {
            "diagnostics",
            symbols = {
              error = icons.diagnosis.error .. " ",
              warn = icons.diagnosis.warn .. " ",
              info = icons.diagnosis.info .. " ",
              hint = icons.diagnosis.hint .. " ",
            },
            always_visible = false,
          },
          "aerial",
        },
        lualine_c = {},
        lualine_x = {
          "filename",
          utils.venv_with_cwd,
          "fileformat",
          "filetype",
          -- function()
          --   return utils.IS_LINUX and not utils.IS_WSL and require("nvim-web-devicons").get_icon("Fluxbox", "fluxbox")
          --     or "" -- fluxbox icon on linux
          -- end,
        },
        lualine_y = {},
        -- lualine_y = { "progress" },
        -- lualine_z = {},
        lualine_z = { "location" },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
      },
      extensions = { "lazy", "nvim-dap-ui", "mason" },
    }

    require("lualine").setup(opts)
  end,
}
