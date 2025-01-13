-- ipython/R repl
return {
  "hkupty/iron.nvim",
  ft = { "python", "r", "haskell" },
  config = function()
    local iron = require("iron.core")
    iron.setup({
      config = {
        scratch_repl = true,
        repl_definition = {
          python = require("iron.fts.python").ipython,
          R = require("iron.fts.r").R,
          haskell = {
            command = function(args)
              local filename = vim.api.nvim_buf_get_name(args.current_bufnr)
              return { "ghci", filename }
            end,
          },
        },
        -- repl_open_cmd = require("iron.view").split.vertical.botright(60),
        -- repl_open_cmd = require("iron.view").bottom(20),
        repl_open_cmd = "below 20 split",
      },
      ignore_blank_lines = false,
    })

    vim.keymap.set("n", "<c-enter>", function()
      require("iron.core").send_line()
    end, {
      noremap = true,
      silent = true,
      desc = "Send line (iron REPL)",
    })

    vim.keymap.set("v", "<c-enter>", function()
      require("iron.core").visual_send()
    end, {
      noremap = true,
      silent = true,
      desc = "Visual send (iron REPL)",
    })
  end,
}
