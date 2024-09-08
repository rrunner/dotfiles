-- toggle term
return {
  "akinsho/toggleterm.nvim",
  version = "*",
  keys = {
    { "<c-;>", [[<cmd>ToggleTerm<cr>]], mode = "n", desc = "Toggle Terminal", noremap = true, silent = true },
  },
  config = function()
    local opts = {
      open_mapping = [[<c-;>]],
      -- do not open toggleterm in insert mode (independent of open_mapping)
      insert_mappings = false,
      size = 20,
      autochdir = true,
      start_in_insert = true,
      direction = "float",
      auto_scroll = true,
      shade_terminals = false,
      shell = function()
        -- default setting from options.lua
        return vim.o.shell
      end,
      winbar = {
        enabled = false,
      },
      float_opts = {
        border = "curved",
        title_pos = "center",
      },
      -- ISSUE: title does not appear the first when toggleterm opens (hence disable this function)
      -- on_create = function(term)
      --   term.display_name = "Terminal: " .. vim.opt.shell:get()
      --   return term
      -- end,
    }

    local Terminal = require("toggleterm.terminal").Terminal
    local vdata = Terminal:new({ cmd = "visidata", hidden = true, direction = "float", size = 80 })
    local chtsh_python = Terminal:new({ cmd = "cht.sh --shell python", hidden = true, direction = "float", size = 80 })
    local chtsh_r = Terminal:new({ cmd = "cht.sh --shell r", hidden = true, direction = "float", size = 80 })

    function _VISIDATA_TOGGLE()
      vdata:toggle()
    end

    function _CHTSH_PYTHON_TOGGLE()
      chtsh_python:toggle()
    end

    function _CHTSH_R_TOGGLE()
      chtsh_r:toggle()
    end

    require("toggleterm").setup(opts)

    -- additional toggleterm related keybindings
    vim.keymap.set("n", "<leader>vd", function()
      _VISIDATA_TOGGLE()
    end, { noremap = true, silent = true, desc = "Open visidata" })

    vim.keymap.set("n", "<leader>cp", function()
      _CHTSH_PYTHON_TOGGLE()
    end, { noremap = true, silent = true, desc = "Open cht.sh shell for the Python language" })

    vim.keymap.set("n", "<leader>cr", function()
      _CHTSH_R_TOGGLE()
    end, { noremap = true, silent = true, desc = "Open cht.sh shell for the R language" })
  end,
}
