-- treesitter
return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false,
  build = ":TSUpdate",
  dependencies = {
    {
      "nvim-treesitter/nvim-treesitter-textobjects",
      branch = "main",
    },
    "nvim-treesitter/nvim-treesitter-context",
  },
  config = function()
    local nvim_ts = require("nvim-treesitter")
    local utils = require("config.utils")

    local ts_parsers = {
      "bash",
      "bibtex",
      "c",
      "csv",
      "diff",
      "dockerfile",
      "editorconfig",
      "git_config",
      "git_rebase",
      "gitattributes",
      "gitcommit",
      "gitignore",
      "haskell",
      "html",
      "http",
      "hurl",
      "json",
      "json5",
      "jsonc",
      "julia",
      "latex",
      "lua",
      "luadoc",
      "luap",
      "luau",
      "markdown",
      "markdown_inline",
      "matlab",
      "mermaid",
      "psv",
      "python",
      "query",
      "r",
      "regex",
      "requirements",
      "rst",
      "sql",
      "terraform",
      "toml",
      "tsv",
      "vim",
      "vimdoc",
      "xml",
      "yaml",
    }

    -- jsonc does not install on WSL (do not know why...)
    if utils.IS_WSL then
      ts_parsers = vim.tbl_filter(function(item)
        return item ~= "jsonc"
      end, ts_parsers)
    end

    -- install treesitter parsers
    local already_installed = require("nvim-treesitter.config").get_installed("parsers")
    local parsers_to_install = vim
      .iter(ts_parsers)
      :filter(function(parser)
        return not vim.tbl_contains(already_installed, parser)
      end)
      :totable()
    nvim_ts.install(parsers_to_install, { summary = true })

    -- only required to call setup() if non-default options are requested
    -- nvim_ts.setup({})

    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "*" },
      callback = function(args)
        local bufnr = args.buf
        -- treesitter is not available if there is no filetype
        if vim.bo[bufnr].filetype == "" then
          return
        end
        -- no parser available
        if not pcall(vim.treesitter.get_parser, bufnr) then
          return
        end
        -- highlighting
        if not pcall(vim.treesitter.start, bufnr) then
          return
        end
        -- indentation
        if pcall(require, "nvim-treesitter") then
          vim.bo[bufnr].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
        -- folds
        local winid = vim.fn.bufwinid(bufnr)
        vim.wo[winid][0].foldmethod = "expr"
        vim.wo[winid][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
      end,
    })

    -- treesitter textobjects
    require("nvim-treesitter-textobjects").setup({
      select = {
        lookahead = true,
        selection_modes = {
          ["@parameter.outer"] = "v", -- charwise
          ["@function.outer"] = "V", -- linewise
          ["@class.outer"] = "<c-v>", -- blockwise
        },
        include_surrounding_whitespace = false,
      },
      move = {
        set_jumps = false,
      },
    })

    -- select keymaps (capture groups defined in `textobjects.scm`)
    vim.keymap.set({ "x", "o" }, "af", function()
      require("nvim-treesitter-textobjects.select").select_textobject("@function.outer", "textobjects")
    end)

    vim.keymap.set({ "x", "o" }, "if", function()
      require("nvim-treesitter-textobjects.select").select_textobject("@function.inner", "textobjects")
    end)

    vim.keymap.set({ "x", "o" }, "ac", function()
      require("nvim-treesitter-textobjects.select").select_textobject("@class.outer", "textobjects")
    end)

    vim.keymap.set({ "x", "o" }, "ic", function()
      require("nvim-treesitter-textobjects.select").select_textobject("@class.inner", "textobjects")
    end)

    -- move keymaps (capture groups defined in `textobjects.scm`)
    vim.keymap.set({ "n", "x", "o" }, "]f", function()
      require("nvim-treesitter-textobjects.move").goto_next_start("@function.outer", "textobjects")
    end)

    vim.keymap.set({ "n", "x", "o" }, "[f", function()
      require("nvim-treesitter-textobjects.move").goto_previous_start("@function.outer", "textobjects")
    end)

    vim.keymap.set({ "n", "x", "o" }, "]]", function()
      require("nvim-treesitter-textobjects.move").goto_next_start("@class.outer", "textobjects")
    end)

    vim.keymap.set({ "n", "x", "o" }, "[[", function()
      require("nvim-treesitter-textobjects.move").goto_previous_start("@class.outer", "textobjects")
    end)

    vim.keymap.set({ "n", "x", "o" }, "]a", function()
      require("nvim-treesitter-textobjects.move").goto_next_start({ "@parameter.inner" }, "textobjects")
    end)

    vim.keymap.set({ "n", "x", "o" }, "[a", function()
      require("nvim-treesitter-textobjects.move").goto_previous_start({ "@parameter.inner" }, "textobjects")
    end)

    -- treesitter context
    require("treesitter-context").setup({
      multiline_threshold = 1,
    })
  end,
}
