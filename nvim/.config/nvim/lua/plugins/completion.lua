-- completion
local has_words_before = function()
  if vim.bo[0].buftype == "prompt" then
    return false
  end
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local feedkey = function(key, mode)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end

return {
  "hrsh7th/nvim-cmp",
  version = false,
  event = { "InsertEnter", "CmdlineEnter" },
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-nvim-lua",
    "hrsh7th/cmp-cmdline",
    "hrsh7th/cmp-omni",
    {
      "saadparwaiz1/cmp_luasnip",
      {
        "L3MON4D3/LuaSnip",
        dependencies = {
          {
            "rafamadriz/friendly-snippets",
            config = function()
              -- enable vscode snippets
              require("luasnip.loaders.from_vscode").lazy_load()
              -- require("luasnip.loaders.from_vscode").lazy_load({ paths = vim.fn.stdpath("config") .. "/snippets" })
            end,
          },
        },
        build = "make install_jsregexp",
      },
    },
  },
  config = function()
    local cmp = require("cmp")
    local luasnip = require("luasnip")
    local cmp_autopairs = require("nvim-autopairs.completion.cmp")

    -- link quarto and rmarkdown to markdown snippets
    luasnip.filetype_extend("quarto", { "markdown" })
    luasnip.filetype_extend("rmarkdown", { "markdown" })

    -- define global highlight group: ghost text in completion
    vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })

    -- insert `(` after select function or method
    cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

    cmp.setup({
      -- prevent preselection of the top menu item
      preselect = cmp.PreselectMode.None,
      -- snippets
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      -- same as in options.lua
      completion = {
        completeopt = "menu,menuone,noselect",
      },
      -- mappings
      mapping = cmp.mapping.preset.insert({
        ["<c-n>"] = cmp.mapping({
          c = function()
            if cmp.visible() then
              cmp.select_next_item()
            else
              feedkey("<down>", "n")
            end
          end,
          i = function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            else
              fallback()
            end
          end,
          s = function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            else
              fallback()
            end
          end,
        }),
        ["<c-p>"] = cmp.mapping({
          c = function()
            if cmp.visible() then
              cmp.select_prev_item()
            else
              feedkey("<up>", "n")
            end
          end,
          i = function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            else
              fallback()
            end
          end,
          s = function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            else
              fallback()
            end
          end,
        }),
        ["<c-d>"] = cmp.mapping.scroll_docs(2),
        ["<c-f>"] = cmp.mapping.scroll_docs(-2),
        ["<c-space>"] = cmp.mapping.complete(),
        ["<c-e>"] = cmp.mapping({
          i = function()
            if cmp.visible() then
              cmp.abort()
            end
          end,
          c = cmp.close(),
        }),
        ["<c-y>"] = cmp.mapping(
          cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
          }),
          { "i", "s" }
        ),
        ["<cr>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            if cmp.get_active_entry() then
              cmp.confirm({ behavior = cmp.ConfirmBehavior.Insert, select = false })
            else
              fallback()
            end
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            if #cmp.get_entries() == 1 then
              cmp.confirm({ select = true })
            else
              cmp.select_next_item()
            end
          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          elseif has_words_before() then
            cmp.complete()
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<s-tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            if #cmp.get_entries() == 1 then
              cmp.confirm({ select = true })
            else
              cmp.select_prev_item()
            end
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),
      }),
      formatting = {
        fields = { "kind", "abbr", "menu" },
        format = function(entry, vim_item)
          vim_item.kind = string.format("%s", icons._kinds_cmp[vim_item.kind])
          vim_item.menu = ({
            nvim_lsp = "[Lsp]",
            luasnip = "[Snip]",
            buffer = "[Buff]",
            path = "[Path]",
            nvim_lua = "[Lua]",
            cmdline = "[Cmd]",
            dap = "[Dap]",
            omni = "[Omni]",
            otter = "[Otter]",
          })[entry.source.name]
          return vim_item
        end,
      },
      sources = {
        {
          name = "lazydev",
          -- set group index to 0 to skip loading LuaLS completions as lazydev recommends it
          group_index = 0,
        },
        {
          name = "nvim_lsp",
          entry_filter = function(entry, _)
            return require("cmp.types").lsp.CompletionItemKind[entry:get_kind()] ~= "Text"
          end,
        },
        {
          name = "luasnip",
          max_item_count = 5,
          entry_filter = function()
            local context = require("cmp.config.context")
            return not context.in_treesitter_capture("string") and not context.in_syntax_group("String")
          end,
        },
        {
          name = "buffer",
          max_item_count = 5,
          keyword_length = 3,
        },
        {
          name = "nvim_lua",
          entry_filter = function(entry, _)
            return require("cmp.types").lsp.CompletionItemKind[entry:get_kind()] ~= "Text"
          end,
        },
        {
          name = "path",
          max_item_count = 10,
          trigger_character = { "/" },
        },
        {
          name = "otter",
          max_item_count = 10,
        },
      },
      view = {
        docs = {
          auto_open = true,
        },
        entries = {
          follow_cursor = true,
        },
      },
      window = {
        documentation = {
          border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
          winhighlight = "Normal:CmpPmenu,FloatBorder:CmpPmenuBorder,CursorLine:PmenuSel,Search:None",
          max_height = 25,
          max_width = 60,
        },
        completion = {
          border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
          winhighlight = "Normal:CmpPmenu,FloatBorder:CmpPmenuBorder,CursorLine:PmenuSel,Search:None",
          scrolloff = 3,
          side_padding = 1,
          scrollbar = false,
          col_offset = -1,
        },
      },
      experimental = {
        ghost_text = {
          hl_group = "CmpGhostText",
        },
      },
    })

    -- completion in command line mode
    cmp.setup.cmdline(":", {
      completion = { autocomplete = false }, -- required to make <c-n> and <c-p> to work
      mapping = cmp.mapping.preset.cmdline({
        ["<cr>"] = cmp.mapping(function(fallback)
          if cmp.visible() and cmp.get_active_entry() then
            cmp.confirm()
          else
            fallback()
          end
        end, { "c" }),
        ["<c-y>"] = cmp.mapping(function()
          if cmp.visible() then
            cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true })
          end
        end, { "c" }),
        -- keybinds below is an attempt to align with readline
        ["<c-b>"] = cmp.mapping(function()
          feedkey("<left>", "c")
        end, { "c" }),
        ["<c-f>"] = cmp.mapping(function()
          feedkey("<right>", "c")
        end, { "c" }),
        ["<c-d>"] = cmp.mapping(function()
          -- nothing
        end, { "c" }),
        ["<c-a>"] = cmp.mapping(function()
          feedkey("<home>", "c")
        end, { "c" }),
        ["<c-e>"] = cmp.mapping(function()
          feedkey("<end>", "c")
        end, { "c" }),
        ["<c-n>"] = cmp.mapping(function()
          if cmp.visible() then
            cmp.select_next_item()
          else
            -- cmd history (up/down keys)
            feedkey("<down>", "c")
          end
        end, { "c" }),
        ["<c-p>"] = cmp.mapping(function()
          if cmp.visible() then
            cmp.select_prev_item()
          else
            -- cmd history (up/down keys)
            feedkey("<up>", "c")
          end
        end, { "c" }),
      }),
      sources = cmp.config.sources({
        {
          name = "path",
        },
      }, {
        {
          name = "cmdline",
          option = {
            ignore_cmds = { "Man", "!" },
          },
        },
      }),
    })

    -- completion in / and ? search mode
    cmp.setup.cmdline({ "/", "?" }, {
      mapping = cmp.mapping.preset.cmdline({
        ["<cr>"] = cmp.mapping(function(fallback)
          if cmp.visible() and cmp.get_active_entry() then
            cmp.confirm()
          else
            fallback()
          end
        end, { "i", "s", "c" }),
        ["<c-y>"] = cmp.mapping(function()
          if cmp.visible() then
            cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true })
          end
        end, { "i", "s", "c" }),
      }),
      sources = cmp.config.sources({}, {
        {
          name = "buffer",
          max_item_count = 10,
          keyword_length = 1,
        },
      }),
    })

    -- limit completion sources for certain filetypes
    cmp.setup.filetype({ "markdown", "text", "mail" }, {
      sources = {
        { name = "path" },
        {
          name = "buffer",
          max_item_count = 10,
          keyword_length = 3,
          option = {
            -- get completions from all visible buffers (in the filetypes specified in this block)
            get_bufnrs = function()
              local bufs = {}
              for _, win in ipairs(vim.api.nvim_list_wins()) do
                bufs[vim.api.nvim_win_get_buf(win)] = true
              end
              return vim.tbl_keys(bufs)
            end,
          },
        },
      },
    })

    -- completion in snacks_input (vim.ui.input)
    cmp.setup.filetype({ "snacks_input" }, {
      -- keybinds below is an attempt to align with readline
      mapping = cmp.mapping.preset.insert({
        ["<c-e>"] = cmp.mapping({
          i = function()
            feedkey("<end>", "i")
          end,
        }),
        ["<c-a>"] = cmp.mapping({
          i = function()
            feedkey("<home>", "i")
          end,
        }),
        ["<c-b>"] = cmp.mapping({
          i = function()
            feedkey("<left>", "i")
          end,
        }),
        ["<c-f>"] = cmp.mapping({
          i = function()
            feedkey("<right>", "i")
          end,
        }),
        ["<c-d>"] = cmp.mapping({
          i = function()
            --nothing
          end,
        }),
        ["<c-n>"] = cmp.mapping({
          i = function()
            feedkey("<down>", "i")
          end,
        }),
        ["<c-p>"] = cmp.mapping({
          i = function()
            feedkey("<up>", "i")
          end,
        }),
        ["<c-y>"] = cmp.mapping({
          i = function()
            if cmp.visible() then
              cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true })
            end
          end,
        }),
      }),
    })

    -- completion source for nvim-dap REPL and nvim-dap-ui buffers
    cmp.setup.filetype({ "dap-repl", "dapui_watches", "dapui_hover" }, {
      sources = {
        { name = "dap" },
        {
          name = "buffer",
          keyword_length = 1,
          max_item_count = 5,
          option = {
            -- get completions from all active buffers (to get completions also from python and yaml (configuration files))
            get_bufnrs = function()
              local bufs = {}
              local ft = { "dap-repl", "dapui_watches", "dapui_hover", "python", "yaml" }
              for _, bu in ipairs(vim.api.nvim_list_bufs()) do
                if vim.tbl_contains(ft, vim.bo[bu].filetype) then
                  bufs[bu] = true
                end
              end
              return vim.tbl_keys(bufs)
            end,
          },
        },
        {
          name = "path",
          max_item_count = 10,
          trigger_character = { "/" },
        },
      },
      mapping = cmp.mapping.preset.insert({
        ["<c-n>"] = cmp.mapping({
          i = function()
            if cmp.visible() then
              cmp.select_next_item()
            else
              feedkey("<down>", "i")
            end
          end,
        }),
        ["<c-p>"] = cmp.mapping({
          i = function()
            if cmp.visible() then
              cmp.select_prev_item()
            else
              feedkey("<up>", "i")
            end
          end,
        }),
        ["<c-y>"] = cmp.mapping(
          cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
          }),
          { "i", "s" }
        ),
        ["<cr>"] = cmp.mapping(function(fallback)
          if cmp.visible() and cmp.get_active_entry() then
            cmp.confirm()
          else
            fallback()
          end
        end, { "i", "s" }),
      }),
    })
  end,
}
