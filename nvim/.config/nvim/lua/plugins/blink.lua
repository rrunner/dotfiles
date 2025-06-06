local feedkey = function(key, mode)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end

return {
  "saghen/blink.cmp",
  event = "VimEnter",
  version = "1.*", -- use a release tag to download pre-built binaries
  dependencies = {
    "rafamadriz/friendly-snippets",
    "folke/lazydev.nvim",
    {
      "Kaiser-Yang/blink-cmp-dictionary",
      dependencies = { "nvim-lua/plenary.nvim" },
      -- possible to replace fzf dependency with ripgrep (see plugin README file)
      -- also requires wn (WordNet) to get definitions of words (https://aur.archlinux.org/pkgbase/wordnet in arch AUR)
      cond = vim.fn.executable("fzf") and vim.fn.executable("cat"),
    },
    "mikavilpas/blink-ripgrep.nvim",
  },
  opts = {
    sources = {
      -- dynamically set providers by treesitter node/filetype
      default = function()
        local ft = vim.bo.filetype
        local success, node = pcall(vim.treesitter.get_node)
        if
          success
          and node
          and vim.tbl_contains(
            { "comment", "line_comment", "block_comment", "string_start", "string_content", "string_end" },
            node:type()
          )
        then
          return { "buffer", "ripgrep" }
        elseif ft == "lua" then
          return { "lazydev", "lsp", "path", "snippets", "buffer" }
        elseif ft == "gitcommit" then
          return {}
        elseif ft == "markdown" then
          return { "buffer", "snippets", "dictionary" }
        elseif ft == "dap-repl" then
          return { "buffer" }
        elseif vim.tbl_contains({ "quarto", "rmd" }, ft) then
          return { "buffer", "snippets" }
        elseif vim.tbl_contains({ "text", "mail" }, ft) then
          return { "buffer", "dictionary", "ripgrep" }
        else
          return { "lsp", "path", "snippets", "buffer", "omni" }
        end
      end,
      providers = {
        lsp = {
          max_items = 10,
          score_offset = 10,
        },
        path = {
          max_items = 5,
          opts = {
            get_cwd = vim.uv.cwd,
            show_hidden_files_by_default = true,
          },
          score_offset = 1,
        },
        -- add VSCode style custom snippets to ~/.config/nvim/snippets
        snippets = {
          max_items = 6,
          score_offset = 5,
          opts = {
            ignored_filetypes = {},
          },
        },
        buffer = {
          max_items = 5,
          min_keyword_length = function()
            if vim.bo.filetype == "dap-repl" then
              return 1
            else
              return 3
            end
          end,
          score_offset = -3,
        },
        lazydev = {
          name = "LazyDev",
          module = "lazydev.integrations.blink",
          score_offset = -5,
        },
        dictionary = {
          module = "blink-cmp-dictionary",
          name = "Dict",
          max_items = 6,
          min_keyword_length = 4,
          opts = {
            -- make sure words are different in the files to avoid duplicates
            dictionary_files = nil, -- *.dict files
            -- english words: https://github.com/dwyl/english-words/blob/master/words_alpha.txt
            dictionary_directories = { vim.fn.expand("~/.config/nvim/dictionary") }, -- *.txt files (all files in folder will be loaded)
          },
        },
        ripgrep = {
          module = "blink-ripgrep",
          name = "Ripgrep",
          opts = {
            -- see `rg --help` for an exact description of the values that ripgrep expects
            -- the minimum length of the current word to start searching
            prefix_min_len = 4,
            -- the number of lines to show around each match in the preview (documentation) window
            context_size = 5,
            -- specifies how to find the root of the project where the ripgrep search will start from
            project_root_marker = { ".git" },
            -- enable fallback to cwd if project_root_marker is not found
            project_root_fallback = true,
            search_casing = "--smart-case",
            additional_rg_options = {},
            fallback_to_regex_highlighting = true,
            -- absolute root paths where the rg command will not be executed
            ignore_paths = {},
            -- any additional paths to search in (in addition to the project root)
            additional_paths = {},
          },
        },
      },
    },

    keymap = {
      preset = "default",
      ["<c-space>"] = { "show", "show_documentation", "hide_documentation" },
      ["<c-y>"] = { "select_and_accept", "fallback" },
      ["<c-e>"] = { "fallback" },
      ["<c-k>"] = { "fallback" },
      ["<c-c>"] = { "hide", "fallback" },
      ["<c-s>"] = { "show_signature", "hide_signature", "fallback" },
      ["<c-u>"] = { "scroll_documentation_up", "fallback" },
      ["<c-d>"] = { "scroll_documentation_down", "fallback" },
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
      list = {
        cycle = {
          from_top = false,
        },
      },
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 500,
        window = {
          border = "rounded",
          max_height = 25,
          max_width = 60,
        },
        -- set to false if high CPU usage
        treesitter_highlighting = true,
      },
      ghost_text = {
        enabled = false,
      },
      accept = {
        auto_brackets = {
          enabled = true,
          kind_resolution = {
            enabled = true,
          },
          semantic_token_resolution = {
            enabled = true,
          },
        },
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
      -- readline keymaps
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
