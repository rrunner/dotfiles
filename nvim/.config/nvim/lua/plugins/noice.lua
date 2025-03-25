-- noice (replaces the UI for messages, cmdline and the popupmenu)
return {
  "folke/noice.nvim",
  enabled = true,
  event = "VeryLazy",
  dependencies = {
    "MunifTanjim/nui.nvim",
  },
  config = function()
    -- change required by noice
    vim.opt.lazyredraw = false
    -- managed via autocmds (still set cmdheight here)
    vim.opt.cmdheight = 0
    -- managed via general_settings.lua
    -- (disable W below to suppress write notifications since this is managed via routes below)
    vim.opt.shortmess:append({ W = false })

    require("noice").setup({
      cmdline = {
        view = "cmdline_popup",
        format = {
          search_down = {
            view = "cmdline_popup",
            kind = "search",
            pattern = "^/",
            icon = " ",
            lang = "regex",
          },
          search_up = {
            view = "cmdline_popup",
            kind = "search",
            pattern = "^%?",
            icon = " ",
            lang = "regex",
          },
        },
      },
      views = {
        cmdline_popup = {
          position = {
            row = "50%",
            col = "50%",
          },
        },
      },
      lsp = {
        -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
        signature = {
          auto_open = {
            -- automatically show signature help when typing a trigger character from the LSP
            trigger = false,
          },
        },
      },
      presets = {
        -- cmdline for / and ? location
        bottom_search = true,
        -- position the cmdline and popupmenu together
        command_palette = false,
        -- long messages will be sent to a split
        long_message_to_split = true,
        -- enables an input dialog for inc-rename.nvim
        inc_rename = false,
        -- add a border to hover docs and signature help
        lsp_doc_border = true,
      },
      routes = {
        {
          filter = { event = "msg_show", kind = "", find = "written" },
          opts = { skip = true },
        },
        {
          view = "split",
          filter = { event = "msg_show", min_height = 20 },
        },
        {
          filter = { event = "notify", find = "No information available" },
          opts = { skip = true },
        },
        {
          filter = { event = "msg_show", find = "No changes found" },
          opts = { skip = true },
        },
      },
    })

    vim.keymap.set({ "n", "s", "i" }, "<c-d>", function()
      if not require("noice.lsp").scroll(2) then
        return "<c-d>"
      end
    end, {
      silent = true,
      expr = true,
      desc = "Scroll forward (set in Noice config)",
    })

    vim.keymap.set({ "n", "s" }, "<c-f>", function()
      if not require("noice.lsp").scroll(-2) then
        return "<c-f>"
      end
    end, {
      silent = true,
      expr = true,
      desc = "Scroll backward (set in Noice config)",
    })
  end,
}
