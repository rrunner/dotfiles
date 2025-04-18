local feedkey = function(key, mode)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end

return {
  "saghen/blink.cmp",
  -- optional: friendly-snippets provides snippets for the snippet source
  dependencies = { "rafamadriz/friendly-snippets" },

  -- use a release tag to download pre-built binaries
  version = "1.*",

  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {

    sources = {
      default = { "lsp", "path", "snippets", "buffer", "omni" },
      per_filetype = { "lsp", "path", "snippets", "buffer", "lazydev" },
      providers = {
        path = {
          max_items = 10,
          opts = { get_cwd = vim.uv.cwd },
        },
        snippets = {
          max_items = 3,
          score_offset = -1,
        },
        buffer = {
          max_items = 5,
          min_keyword_length = 3,
          score_offset = -3,
        },
        lazydev = {
          name = "LazyDev",
          module = "lazydev.integrations.blink",
          score_offset = -5,
        },
      },
    },

    -- see :h blink-cmp-config-keymap for defining your own keymap
    keymap = {
      preset = "default",
      ["<c-e>"] = { "fallback" },
      ["<c-k>"] = { "fallback" },
      ["<c-c>"] = { "hide", "fallback" },
      ["<c-s>"] = { "show_signature", "hide_signature", "fallback" },
      ["<c-d>"] = { "scroll_documentation_up", "fallback" },
      ["<c-f>"] = { "scroll_documentation_down", "fallback" },
      ["<c-b>"] = { "fallback" },
    },

    appearance = {
      nerd_font_variant = "mono",
      -- sets the fallback highlight groups to nvim-cmp's highlight groups
      -- when your theme doesn't support blink.cmp (will be removed in a future release)
      use_nvim_cmp_as_default = true,
      kind_icons = require("config.icons")._kinds_cmp,
    },

    completion = {
      menu = {
        border = "rounded",
        draw = {
          columns = { { "kind_icon" }, { "label", "label_description", "kind", "source_name", gap = 1 } },
          treesitter = { "lsp" },
        },
      },
      documentation = {
        auto_show = false,
        window = {
          border = "rounded",
          max_height = 25,
          max_width = 60,
        },
      },
      ghost_text = {
        enabled = false,
      },
    },

    signature = {
      enabled = true,
      window = {
        border = "rounded",
        show_documentation = false,
        scrollbar = false,
        treesitter_highlighting = true,
      },
    },

    cmdline = {
      enabled = true,
      keymap = {
        preset = "cmdline",
        ["<c-a>"] = {
          function()
            feedkey("<home>", "c")
          end,
        },
        ["<c-e>"] = {
          function()
            feedkey("<end>", "c")
          end,
        },
        ["<c-b>"] = {
          function()
            feedkey("<left>", "c")
          end,
        },
        ["<c-f>"] = {
          function()
            feedkey("<right>", "c")
          end,
        },
      },
      completion = {
        menu = {
          auto_show = function()
            -- only show menu for commands
            return vim.fn.getcmdtype() == ":"
          end,
        },
        ghost_text = { enabled = false },
      },
    },

    -- use Rust fuzzy matcher with lua implementation as fallback
    fuzzy = { implementation = "prefer_rust" },
  },
}
