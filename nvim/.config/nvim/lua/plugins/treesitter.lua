-- treesitter
return {
  "nvim-treesitter/nvim-treesitter",
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

    local ts_parsers = {
      "bash",
      "bibtex",
      "c",
      "csv",
      "diff",
      "dockerfile",
      "editorconfig",
      "eex",
      "elixir",
      "git_config",
      "git_rebase",
      "gitattributes",
      "gitcommit",
      "gitignore",
      "haskell",
      "heex",
      "html",
      "http",
      "hurl",
      "json",
      "json5",
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
      "printf",
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

    -- install treesitter parsers
    local already_installed = require("nvim-treesitter.config").get_installed("parsers")
    local parsers_to_install = vim
      .iter(ts_parsers)
      :filter(function(parser)
        return not vim.tbl_contains(already_installed, parser)
      end)
      :totable()
    nvim_ts.install(parsers_to_install, { summary = true })

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
          vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
        -- folds
        local winid = vim.fn.bufwinid(bufnr)
        vim.wo[winid][0].foldmethod = "expr"
        vim.wo[winid][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
      end,
    })

    -- use specific treesitter parsers for some filetypes
    for ft, lang in pairs({
      git = "diff",
      quarto = "markdown",
      rmd = "markdown",
      livebook = "markdown",
    }) do
      vim.treesitter.language.register(lang, ft)
    end

    -- treesitter textobjects

    -- disable entire built-in ftplugin mappings to avoid conflicts (plugin nvim-treesitter-textobjects)
    vim.g.no_plugin_maps = true

    -- treesitter context
    require("treesitter-context").setup({
      multiline_threshold = 1,
    })
  end,
}
